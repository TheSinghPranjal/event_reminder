import 'google_calendar_api.dart';
import 'google_models.dart';

/// DEVELOPER STUB: stands in for the Google Calendar API.
///
/// It lists a fixed, clearly-labelled set of calendars so the selection
/// screen can be exercised, but it cannot import or write events: those
/// methods always fail, so a stub sync can never be reported as successful.
class StubGoogleCalendarApi implements GoogleCalendarApi {
  const StubGoogleCalendarApi({
    this.latency = const Duration(milliseconds: 600),
  });

  final Duration latency;

  // Colors are Google Calendar's own palette.
  static const calendars = [
    GoogleCalendarInfo(
      id: 'stub@planly.invalid',
      name: 'Personal (stub)',
      color: 0xFF039BE5,
      accessRole: 'owner',
      isPrimary: true,
      selectedInGoogle: true,
    ),
    GoogleCalendarInfo(
      id: 'work-stub@group.calendar.google.com',
      name: 'Work (stub)',
      color: 0xFFF4511E,
      accessRole: 'owner',
      selectedInGoogle: true,
    ),
    GoogleCalendarInfo(
      id: 'addressbook#contacts@group.v.calendar.google.com',
      name: 'Birthdays (stub)',
      color: 0xFFE67C73,
      accessRole: 'reader',
      selectedInGoogle: true,
    ),
    GoogleCalendarInfo(
      id: 'family-stub@group.calendar.google.com',
      name: 'Family (stub)',
      color: 0xFF33B679,
      accessRole: 'writer',
    ),
    GoogleCalendarInfo(
      id: 'en.indian#holiday@group.v.calendar.google.com',
      name: 'Holidays (stub)',
      color: 0xFF8E24AA,
      accessRole: 'reader',
    ),
  ];

  @override
  bool get isStub => true;

  @override
  Future<List<GoogleCalendarInfo>> listCalendars(String accountId) async {
    await Future<void>.delayed(latency);
    return calendars;
  }

  Never _unsupported() => throw const GoogleApiException(
    'Event import isn\'t available yet: this build uses a stub instead of '
    'the Google Calendar API, so no events were downloaded.',
    isStubLimitation: true,
  );

  @override
  Future<GoogleEventPage> listEvents(
    String accountId,
    String calendarId, {
    String? syncToken,
  }) async {
    await Future<void>.delayed(latency);
    _unsupported();
  }

  @override
  Future<GoogleEventInfo> insertEvent(
    String accountId,
    String calendarId,
    GoogleEventDraft draft,
  ) async {
    await Future<void>.delayed(latency);
    _unsupported();
  }

  @override
  Future<GoogleEventInfo> updateEvent(
    String accountId,
    String calendarId,
    String eventId,
    GoogleEventDraft draft, {
    String? etag,
  }) async {
    await Future<void>.delayed(latency);
    _unsupported();
  }

  @override
  Future<void> deleteEvent(
    String accountId,
    String calendarId,
    String eventId,
  ) async {
    await Future<void>.delayed(latency);
    _unsupported();
  }
}
