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
  FakeCalendarApi({required this.calendars, required this.events});

  final List<GoogleCalendarInfo> calendars;
  final Map<String, List<GoogleEventInfo>> events;

  @override
  bool get isStub => false;

  @override
  Future<List<GoogleCalendarInfo>> listCalendars(String accountId) async =>
      calendars;

  @override
  Future<List<GoogleEventInfo>> listEvents(
    String accountId,
    String calendarId,
  ) async => events[calendarId] ?? const [];
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

/// Lets real-async Drift work finish, then settles frames.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }
}
