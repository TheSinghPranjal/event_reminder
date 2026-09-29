import 'google_models.dart';

/// The subset of the Google Calendar API that Planly uses.
abstract interface class GoogleCalendarApi {
  bool get isStub;

  Future<List<GoogleCalendarInfo>> listCalendars(String accountId);

  /// All events for [calendarId]. Throws [GoogleApiException] on failure.
  Future<List<GoogleEventInfo>> listEvents(String accountId, String calendarId);
}
