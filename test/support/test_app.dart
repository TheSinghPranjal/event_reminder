import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:event_reminder/app/app.dart';
import 'package:event_reminder/app/router.dart';
import 'package:event_reminder/data/google/google_calendar_api.dart';
import 'package:event_reminder/data/google/google_models.dart';
import 'package:event_reminder/data/google/stub_google_auth_service.dart';
import 'package:event_reminder/data/google/stub_google_calendar_api.dart';
import 'package:event_reminder/data/local/app_database.dart';
import 'package:event_reminder/data/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

AppDatabase inMemoryDatabase() => AppDatabase(
  DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true),
);

/// Test double for a working Google Calendar API (never used by the app).
class FakeCalendarApi implements GoogleCalendarApi {
  FakeCalendarApi({
    required this.calendars,
    Map<String, List<GoogleEventInfo>>? events,
    this.failNextList = false,
    this.expireSyncTokenOnce = false,
  }) : events = {
         for (final e in (events ?? const {}).entries)
           e.key: List<GoogleEventInfo>.from(e.value),
       };

  final List<GoogleCalendarInfo> calendars;
  final Map<String, List<GoogleEventInfo>> events;
  final Map<String, String> syncTokens = {};
  final List<String> insertedIds = [];
  final List<String> updatedIds = [];
  final List<String> deletedIds = [];

  /// When true, the next [listEvents] throws [GoogleSyncTokenExpiredException]
  /// once, then clears.
  bool expireSyncTokenOnce;

  /// When true, the next [listEvents] throws a generic API error once.
  bool failNextList;

  int _seq = 0;

  @override
  bool get isStub => false;

  @override
  Future<List<GoogleCalendarInfo>> listCalendars(String accountId) async =>
      calendars;

  @override
  Future<GoogleEventPage> listEvents(
    String accountId,
    String calendarId, {
    String? syncToken,
  }) async {
    if (failNextList) {
      failNextList = false;
      throw const GoogleApiException('Simulated list failure');
    }
    if (expireSyncTokenOnce && syncToken != null) {
      expireSyncTokenOnce = false;
      throw const GoogleSyncTokenExpiredException();
    }
    final list = events[calendarId] ?? const <GoogleEventInfo>[];
    final token = 'token-${calendarId.hashCode}-${list.length}';
    syncTokens[calendarId] = token;
    return GoogleEventPage(
      events: List.unmodifiable(list),
      cancelledIds: const [],
      nextSyncToken: token,
    );
  }

  @override
  Future<GoogleEventInfo> insertEvent(
    String accountId,
    String calendarId,
    GoogleEventDraft draft,
  ) async {
    final id = 'fake-${++_seq}';
    final info = GoogleEventInfo(
      id: id,
      title: draft.title,
      start: draft.start,
      end: draft.end,
      isAllDay: draft.isAllDay,
      description: draft.description,
      location: draft.location,
      reminderMinutes: draft.reminderMinutes,
      etag: 'etag-$id',
    );
    events.putIfAbsent(calendarId, () => []).add(info);
    insertedIds.add(id);
    return info;
  }

  @override
  Future<GoogleEventInfo> updateEvent(
    String accountId,
    String calendarId,
    String eventId,
    GoogleEventDraft draft, {
    String? etag,
  }) async {
    final list = events.putIfAbsent(calendarId, () => []);
    final index = list.indexWhere((e) => e.id == eventId);
    final info = GoogleEventInfo(
      id: eventId,
      title: draft.title,
      start: draft.start,
      end: draft.end,
      isAllDay: draft.isAllDay,
      description: draft.description,
      location: draft.location,
      reminderMinutes: draft.reminderMinutes,
      etag: 'etag-$eventId-updated',
    );
    if (index >= 0) {
      list[index] = info;
    } else {
      list.add(info);
    }
    updatedIds.add(eventId);
    return info;
  }

  @override
  Future<void> deleteEvent(
    String accountId,
    String calendarId,
    String eventId,
  ) async {
    events[calendarId]?.removeWhere((e) => e.id == eventId);
    deletedIds.add(eventId);
  }
}

/// Pumps the whole app on [db] with instant stubs and animations disabled
/// (so looping illustration animations don't block pumpAndSettle).
Future<void> pumpPlanly(
  WidgetTester tester, {
  required AppDatabase db,
  String initialLocation = '/',
  GoogleCalendarApi? calendarApi,
}) async {
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        initialLocationProvider.overrideWithValue(initialLocation),
        googleAuthServiceProvider.overrideWithValue(
          const StubGoogleAuthService(latency: Duration.zero),
        ),
        googleCalendarApiProvider.overrideWithValue(
          calendarApi ?? const StubGoogleCalendarApi(latency: Duration.zero),
        ),
      ],
      child: const PlanlyApp(),
    ),
  );
  await settle(tester);
}

/// Lets real-async Drift work finish, then pumps frames without waiting on
/// unbounded animations (progress indicators, looping illustrations).
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pump(const Duration(milliseconds: 50));
  }
}
