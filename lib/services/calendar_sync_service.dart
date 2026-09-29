import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/google/google_calendar_api.dart';
import '../data/google/google_models.dart';
import '../data/providers.dart';
import '../data/repositories/account_repository.dart';
import '../data/repositories/calendar_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/event_repository.dart';
import 'event_push_service.dart';

enum SyncStage {
  connect,
  pushChanges,
  loadCalendars,
  importEvents,
  findBirthdays,
}

/// Real counts produced by a sync run (partial when the run failed).
class SyncReport {
  const SyncReport({
    this.calendars = 0,
    this.events = 0,
    this.birthdays = 0,
    this.pushed = 0,
  });

  final int calendars;
  final int events;
  final int birthdays;
  final int pushed;

  SyncReport copyWith({
    int? calendars,
    int? events,
    int? birthdays,
    int? pushed,
  }) => SyncReport(
    calendars: calendars ?? this.calendars,
    events: events ?? this.events,
    birthdays: birthdays ?? this.birthdays,
    pushed: pushed ?? this.pushed,
  );
}

sealed class SyncUpdate {
  const SyncUpdate();
}

class SyncStageStarted extends SyncUpdate {
  const SyncStageStarted(this.stage);
  final SyncStage stage;
}

/// Progress inside a stage, e.g. "Imported 120 events".
class SyncStageProgress extends SyncUpdate {
  const SyncStageProgress(this.stage, this.detail);
  final SyncStage stage;
  final String detail;
}

class SyncStageCompleted extends SyncUpdate {
  const SyncStageCompleted(this.stage, this.detail);
  final SyncStage stage;
  final String detail;
}

class SyncSucceeded extends SyncUpdate {
  const SyncSucceeded(this.report);
  final SyncReport report;
}

class SyncFailed extends SyncUpdate {
  const SyncFailed(
    this.stage,
    this.message, {
    required this.partial,
    this.isStubLimitation = false,
  });

  final SyncStage stage;
  final String message;
  final SyncReport partial;
  final bool isStubLimitation;
}

/// Downloads selected Google calendars into the local database.
///
/// Every count reported comes from what was actually written. Success is only
/// emitted (and recorded) when every stage completed.
class CalendarSyncService {
  CalendarSyncService({
    required GoogleCalendarApi api,
    required AccountRepository accounts,
    required CalendarRepository calendars,
    required EventRepository events,
    required CategoryRepository categories,
    required EventPushService push,
    DateTime Function() clock = DateTime.now,
  }) : _api = api,
       _accounts = accounts,
       _calendars = calendars,
       _events = events,
       _categories = categories,
       _push = push,
       _clock = clock;

  final GoogleCalendarApi _api;
  final AccountRepository _accounts;
  final CalendarRepository _calendars;
  final EventRepository _events;
  final CategoryRepository _categories;
  final EventPushService _push;
  final DateTime Function() _clock;

  Stream<SyncUpdate> run(String accountId) async* {
    var stage = SyncStage.connect;
    var report = const SyncReport();

    Future<SyncFailed> fail(String message, {bool stub = false}) async {
      await _accounts.recordSyncFailure(accountId, _clock(), message);
      return SyncFailed(
        stage,
        message,
        partial: report,
        isStubLimitation: stub,
      );
    }

    try {
      yield SyncStageStarted(stage);
      final account = await _accounts.find(accountId);
      if (account == null) {
        yield await fail('This Google account is no longer connected.');
        return;
      }
      if (!account.calendarAccessGranted) {
        yield await fail('Calendar access hasn\'t been granted yet.');
        return;
      }
      yield SyncStageCompleted(
        stage,
        account.isStub ? 'Connected (stub account)' : 'Connected to Google',
      );

      stage = SyncStage.pushChanges;
      yield SyncStageStarted(stage);
      final pushed = await _push.pushPending(accountId);
      report = report.copyWith(pushed: pushed);
      yield SyncStageCompleted(
        stage,
        pushed == 0
            ? 'No local changes to upload'
            : 'Uploaded ${_plural(pushed, 'change')}',
      );

      stage = SyncStage.loadCalendars;
      yield SyncStageStarted(stage);
      await _calendars.refreshMetadata(
        accountId,
        await _api.listCalendars(accountId),
      );
      final selected = await _calendars.selected(accountId);
      if (selected.isEmpty) {
        yield await fail('No calendars are selected for sync.');
        return;
      }
      report = report.copyWith(calendars: selected.length);
      yield SyncStageCompleted(
        stage,
        'Loaded ${_plural(selected.length, 'calendar')}',
      );

      stage = SyncStage.importEvents;
      yield SyncStageStarted(stage);
      for (final calendar in selected) {
        GoogleEventPage page;
        try {
          page = await _api.listEvents(
            accountId,
            calendar.googleCalendarId,
            syncToken: calendar.syncToken,
          );
        } on GoogleSyncTokenExpiredException {
          await _calendars.clearSyncToken(calendar.id);
          page = await _api.listEvents(
            accountId,
            calendar.googleCalendarId,
          );
        }
        final written = await _events.applyRemoteDelta(calendar.id, page);
        if (page.nextSyncToken != null) {
          await _calendars.setSyncToken(calendar.id, page.nextSyncToken);
        }
        report = report.copyWith(events: report.events + written);
        yield SyncStageProgress(
          stage,
          'Imported ${_plural(report.events, 'event')}',
        );
      }
      yield SyncStageCompleted(
        stage,
        'Imported ${_plural(report.events, 'event')}',
      );

      stage = SyncStage.findBirthdays;
      yield SyncStageStarted(stage);
      final birthdayCategory = await _categories.findBySlug('birthdays');
      final birthdays = birthdayCategory == null
          ? await _events.countForAccount(accountId, birthdaysOnly: true)
          : await _events.categorizeBirthdays(accountId, birthdayCategory.id);
      report = report.copyWith(birthdays: birthdays);
      yield SyncStageCompleted(
        stage,
        'Found ${_plural(birthdays, 'birthday')}',
      );

      await _accounts.recordSyncSuccess(accountId, _clock());
      yield SyncSucceeded(report);
    } on GoogleApiException catch (e) {
      yield await fail(e.message, stub: e.isStubLimitation);
    } catch (_) {
      yield await fail(
        'Something went wrong while syncing. Your data is safe.',
      );
    }
  }

  static String _plural(int n, String noun) => '$n $noun${n == 1 ? '' : 's'}';
}

final calendarSyncServiceProvider = Provider<CalendarSyncService>(
  (ref) => CalendarSyncService(
    api: ref.watch(googleCalendarApiProvider),
    accounts: ref.watch(accountRepositoryProvider),
    calendars: ref.watch(calendarRepositoryProvider),
    events: ref.watch(eventRepositoryProvider),
    categories: ref.watch(categoryRepositoryProvider),
    push: ref.watch(eventPushServiceProvider),
  ),
);
