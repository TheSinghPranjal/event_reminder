import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/google/google_calendar_api.dart';
import '../data/google/google_models.dart';
import '../data/local/app_database.dart';
import '../data/local/tables/events.dart';
import '../data/providers.dart';
import '../data/repositories/calendar_repository.dart';
import '../data/repositories/event_repository.dart';

/// Pushes local pending creates/updates/deletes to Google Calendar.
///
/// One failure does not abort the rest; each row is marked synced or failed.
class EventPushService {
  EventPushService({
    required GoogleCalendarApi api,
    required EventRepository events,
    required CalendarRepository calendars,
  }) : _api = api,
       _events = events,
       _calendars = calendars;

  final GoogleCalendarApi _api;
  final EventRepository _events;
  final CalendarRepository _calendars;

  /// Returns how many pending rows were successfully pushed.
  Future<int> pushPending(String accountId) async {
    final pending = await _events.pendingFor(accountId);
    var ok = 0;
    for (final row in pending) {
      final calendarId = row.calendarId;
      if (calendarId == null) continue;
      final calendar = await _calendars.find(calendarId);
      if (calendar == null) {
        await _events.markFailed(row.id, 'Calendar is no longer available.');
        continue;
      }
      try {
        final pushed = await _pushOne(accountId, calendar, row);
        if (pushed) ok++;
      } on GoogleApiException catch (e) {
        if (row.syncStatus == EventSyncStatus.pendingDelete) {
          await _events.markSyncError(row.id, e.message);
        } else {
          await _events.markFailed(row.id, e.message);
        }
      } catch (_) {
        final message =
            'Something went wrong while updating Google Calendar.';
        if (row.syncStatus == EventSyncStatus.pendingDelete) {
          await _events.markSyncError(row.id, message);
        } else {
          await _events.markFailed(row.id, message);
        }
      }
    }
    return ok;
  }

  Future<bool> _pushOne(
    String accountId,
    SyncedCalendar calendar,
    CalendarEvent row,
  ) async {
    final status = row.syncStatus;
    final googleId = row.googleEventId;

    if (status == EventSyncStatus.pendingDelete) {
      if (googleId != null) {
        await _api.deleteEvent(accountId, calendar.googleCalendarId, googleId);
      }
      await _events.hardDelete(row.id);
      return true;
    }

    // failed with no google id (or pendingCreate) → insert
    if (status == EventSyncStatus.pendingCreate ||
        (status == EventSyncStatus.failed && googleId == null)) {
      final created = await _api.insertEvent(
        accountId,
        calendar.googleCalendarId,
        _draftOf(row),
      );
      await _events.markSynced(
        row.id,
        googleEventId: created.id,
        etag: created.etag,
      );
      return true;
    }

    // pendingUpdate or failed-with-id → update
    if (status == EventSyncStatus.pendingUpdate ||
        status == EventSyncStatus.failed) {
      if (googleId == null) {
        await _events.markFailed(row.id, 'Missing Google event id.');
        return false;
      }
      final updated = await _api.updateEvent(
        accountId,
        calendar.googleCalendarId,
        googleId,
        _draftOf(row),
        etag: row.etag,
      );
      await _events.markSynced(
        row.id,
        googleEventId: updated.id,
        etag: updated.etag,
      );
      return true;
    }

    return false;
  }

  static GoogleEventDraft _draftOf(CalendarEvent row) => GoogleEventDraft(
    title: row.title,
    start: row.startsAt,
    end: row.endsAt,
    isAllDay: row.isAllDay,
    description: row.description,
    location: row.location,
    reminderMinutes: row.reminderMinutes,
  );
}

final eventPushServiceProvider = Provider<EventPushService>(
  (ref) => EventPushService(
    api: ref.watch(googleCalendarApiProvider),
    events: ref.watch(eventRepositoryProvider),
    calendars: ref.watch(calendarRepositoryProvider),
  ),
);
