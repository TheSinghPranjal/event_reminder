/// Plain models for data coming from Google, independent of the database.
class GoogleAccountInfo {
  const GoogleAccountInfo({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.isStub = false,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  /// True when produced by the developer stub instead of Google.
  final bool isStub;
}

class GoogleCalendarInfo {
  const GoogleCalendarInfo({
    required this.id,
    required this.name,
    required this.color,
    required this.accessRole,
    this.isPrimary = false,
    this.selectedInGoogle = false,
  });

  final String id;
  final String name;

  /// ARGB background color as configured in Google Calendar.
  final int color;

  /// owner, writer, reader or freeBusyReader.
  final String accessRole;
  final bool isPrimary;

  /// Whether the calendar is checked in the user's Google Calendar list.
  final bool selectedInGoogle;

  bool get isWritable => accessRole == 'owner' || accessRole == 'writer';

  /// Google's auto-generated contacts birthday calendar.
  bool get isBirthdayCalendar => id.startsWith('addressbook#contacts@');

  bool get isHolidayCalendar => id.contains('#holiday@');
}

class GoogleEventInfo {
  const GoogleEventInfo({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    this.isAllDay = false,
    this.eventType = 'default',
    this.description,
    this.location,
    this.reminderMinutes,
  });

  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final bool isAllDay;

  /// Google's `eventType` (`default`, `birthday`, `focusTime`, ...).
  final String eventType;
  final String? description;
  final String? location;

  /// Minutes before [start] of the earliest popup reminder, if any.
  final int? reminderMinutes;
}

/// A Google API call failed. [message] is safe to show to the user.
class GoogleApiException implements Exception {
  const GoogleApiException(this.message, {this.isStubLimitation = false});

  final String message;

  /// The failure is because this build uses a stub, not a real outage.
  final bool isStubLimitation;

  @override
  String toString() => 'GoogleApiException: $message';
}
