import 'google_models.dart';

/// The subset of the Google Calendar API that Planly uses.
abstract interface class GoogleCalendarApi {
  bool get isStub;

  Future<List<GoogleCalendarInfo>> listCalendars(String accountId);

  /// Events for [calendarId].
  ///
  /// When [syncToken] is set, returns only changes since that token (no time
  /// window). Otherwise returns events in the API's configured time window.
  /// Throws [GoogleSyncTokenExpiredException] when the token is invalid.
  Future<GoogleEventPage> listEvents(
    String accountId,
    String calendarId, {
    String? syncToken,
  });

  /// Creates an event; returns the Google-assigned id + etag.
  Future<GoogleEventInfo> insertEvent(
    String accountId,
    String calendarId,
    GoogleEventDraft draft,
  );

  /// Updates an existing event. Pass [etag] for If-Match when known.
  Future<GoogleEventInfo> updateEvent(
    String accountId,
    String calendarId,
    String eventId,
    GoogleEventDraft draft, {
    String? etag,
  });

  /// Deletes an event. Missing events (404/410) are treated as success.
  Future<void> deleteEvent(
    String accountId,
    String calendarId,
    String eventId,
  );
}
