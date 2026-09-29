import 'dart:io';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/calendar/v3.dart' as gcal;
import 'package:googleapis_auth/googleapis_auth.dart' as gauth;

import 'google_calendar_api.dart';
import 'google_config.dart';
import 'google_models.dart';
import 'sign_in_google_auth_service.dart';

/// Google Calendar API v3 over REST, authorized through Google Sign-In.
class RestGoogleCalendarApi implements GoogleCalendarApi {
  RestGoogleCalendarApi(
    this._auth, {
    this.pastWindow = const Duration(days: 30),
    this.futureWindow = const Duration(days: 365),
  });

  final SignInGoogleAuthService _auth;

  /// Range of events imported around today.
  final Duration pastWindow;
  final Duration futureWindow;

  /// Calendar default reminders, cached from the last [listCalendars].
  final _defaultReminders = <String, int?>{};

  @override
  bool get isStub => false;

  Future<T> _withApi<T>(
    String accountId,
    Future<T> Function(gcal.CalendarApi api) body,
  ) async {
    final user = await _auth.currentAccount();
    if (user == null || user.id != accountId) {
      throw const GoogleApiException(
        'Your Google session expired. Reconnect Google to keep syncing.',
      );
    }
    final authorization = await user.authorizationClient.authorizationForScopes(
      GoogleConfig.calendarScopes,
    );
    if (authorization == null) {
      throw const GoogleApiException(
        'Calendar access was revoked. Grant access again to keep syncing.',
      );
    }
    final client = authorization.authClient(
      scopes: GoogleConfig.calendarScopes,
    );
    try {
      return await body(gcal.CalendarApi(client));
    } on gcal.DetailedApiRequestError catch (e) {
      throw GoogleApiException(switch (e.status) {
        401 || 403 =>
          'Google refused access to your calendars. '
              'Reconnect Google and try again.',
        429 => 'Google is rate-limiting requests. Try again in a minute.',
        _ => 'Google Calendar returned an error (${e.status}).',
      });
    } on gauth.AccessDeniedException {
      throw const GoogleApiException(
        'Google refused access to your calendars. Reconnect and try again.',
      );
    } on SocketException {
      throw const GoogleApiException(
        'Couldn\'t reach Google. Check your connection and try again.',
      );
    } finally {
      client.close();
    }
  }

  @override
  Future<List<GoogleCalendarInfo>> listCalendars(String accountId) {
    return _withApi(accountId, (api) async {
      final result = <GoogleCalendarInfo>[];
      String? pageToken;
      do {
        final page = await api.calendarList.list(pageToken: pageToken);
        for (final c in page.items ?? const <gcal.CalendarListEntry>[]) {
          final id = c.id;
          if (id == null) continue;
          _defaultReminders[id] = _earliestPopup(c.defaultReminders);
          result.add(
            GoogleCalendarInfo(
              id: id,
              name: c.summaryOverride ?? c.summary ?? id,
              color: _parseColor(c.backgroundColor),
              accessRole: c.accessRole ?? 'reader',
              isPrimary: c.primary ?? false,
              selectedInGoogle: c.selected ?? false,
            ),
          );
        }
        pageToken = page.nextPageToken;
      } while (pageToken != null);
      return result;
    });
  }

  @override
  Future<List<GoogleEventInfo>> listEvents(
    String accountId,
    String calendarId,
  ) {
    return _withApi(accountId, (api) async {
      final now = DateTime.now();
      final result = <GoogleEventInfo>[];
      String? pageToken;
      do {
        final page = await api.events.list(
          calendarId,
          singleEvents: true,
          showDeleted: false,
          maxResults: 2500,
          timeMin: now.subtract(pastWindow).toUtc(),
          timeMax: now.add(futureWindow).toUtc(),
          pageToken: pageToken,
        );
        final fallback =
            _defaultReminders[calendarId] ??
            _earliestPopup(page.defaultReminders);
        for (final e in page.items ?? const <gcal.Event>[]) {
          final info = _toInfo(e, fallback);
          if (info != null) result.add(info);
        }
        pageToken = page.nextPageToken;
      } while (pageToken != null);
      return result;
    });
  }

  static GoogleEventInfo? _toInfo(gcal.Event e, int? defaultReminder) {
    final id = e.id;
    final start = e.start;
    final end = e.end;
    if (id == null || start == null || end == null) return null;
    if (e.status == 'cancelled') return null;

    final isAllDay = start.date != null;
    final startsAt = isAllDay
        ? _dateOnly(start.date!)
        : start.dateTime?.toLocal();
    final endsAt = isAllDay ? _dateOnly(end.date!) : end.dateTime?.toLocal();
    if (startsAt == null || endsAt == null) return null;

    final reminders = e.reminders;
    final reminderMinutes = reminders == null || reminders.useDefault == true
        ? defaultReminder
        : _earliestPopup(reminders.overrides);

    return GoogleEventInfo(
      id: id,
      title: (e.summary?.trim().isNotEmpty ?? false)
          ? e.summary!.trim()
          : '(No title)',
      start: startsAt,
      end: endsAt,
      isAllDay: isAllDay,
      eventType: e.eventType ?? 'default',
      description: e.description,
      location: e.location,
      reminderMinutes: reminderMinutes,
    );
  }

  /// All-day dates are calendar days, not instants: keep them at local
  /// midnight regardless of how the date was parsed.
  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// The reminder that fires first (largest lead time), popup reminders only.
  static int? _earliestPopup(List<gcal.EventReminder>? reminders) {
    int? best;
    for (final r in reminders ?? const <gcal.EventReminder>[]) {
      final minutes = r.minutes;
      if (minutes == null || r.method != 'popup') continue;
      if (best == null || minutes > best) best = minutes;
    }
    return best;
  }

  static int _parseColor(String? hex) {
    final value = int.tryParse((hex ?? '').replaceFirst('#', ''), radix: 16);
    return value == null ? 0xFF039BE5 : 0xFF000000 | value;
  }
}
