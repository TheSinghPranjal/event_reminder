import 'package:event_reminder/app/routes.dart';
import 'package:event_reminder/data/google/google_models.dart';
import 'package:event_reminder/data/repositories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:event_reminder/services/reminder_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

Future<void> tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.pumpAndSettle(); // lay out the scrolled position first
  await tester.tap(find.text(text));
  await settle(tester);
}

void main() {
  testWidgets('first launch: splash → onboarding pages → connect screen', (
    tester,
  ) async {
    final db = inMemoryDatabase();
    addTearDown(db.close);
    await pumpPlanly(tester, db: db);

    expect(find.text('Your day,\norganized.'), findsOneWidget);
    await tapText(tester, 'Continue');
    expect(find.text('Everything from\nyour calendar.'), findsOneWidget);
    await tapText(tester, 'Continue');
    expect(find.text('Never miss\nan important moment.'), findsOneWidget);
    expect(find.text('Continue without Google'), findsOneWidget);

    // Back to page 1 to check Skip leads to the connect screen.
    await tester.drag(find.byType(PageView), const Offset(800, 0));
    await settle(tester);
    await tester.drag(find.byType(PageView), const Offset(800, 0));
    await settle(tester);
    await tapText(tester, 'Skip');
    expect(find.text('Connect your calendar'), findsOneWidget);
    expect(find.textContaining('Developer stub'), findsWidgets);
  });

  testWidgets('continue without Google lands on Home and is remembered', (
    tester,
  ) async {
    final db = inMemoryDatabase();
    addTearDown(db.close);
    await pumpPlanly(tester, db: db, initialLocation: Routes.connect);

    await tapText(tester, 'Use app without Google');
    expect(find.text('Your day is clear'), findsOneWidget);
    expect(await SettingsRepository(db).isOnboardingCompleted(), isTrue);
  });

  testWidgets('stub Google flow ends in an honest failure, not success', (
    tester,
  ) async {
    final db = inMemoryDatabase();
    addTearDown(db.close);
    await pumpPlanly(tester, db: db, initialLocation: Routes.connect);

    await tapText(tester, 'Continue with Google');
    expect(find.text('Allow calendar access'), findsOneWidget);

    await tapText(tester, 'Allow Calendar Access');
    expect(find.text('Choose your calendars'), findsOneWidget);
    expect(find.text('Personal (stub)'), findsOneWidget);
    expect(find.text('Primary · You can edit'), findsOneWidget);

    await tapText(tester, 'Continue');
    expect(find.text('Sync didn\'t finish'), findsOneWidget);
    expect(find.text('Connected (stub account)'), findsOneWidget);
    expect(find.text('Loaded 3 calendars'), findsOneWidget);
    expect(find.text('You\'re all set!'), findsNothing);

    await tapText(tester, 'Continue offline');
    expect(find.text('Sync didn\'t finish · tap to retry'), findsOneWidget);
  });

  testWidgets('a real successful sync shows setup complete with DB counts', (
    tester,
  ) async {
    final db = inMemoryDatabase();
    addTearDown(db.close);
    final day = DateTime.now();
    final api = FakeCalendarApi(
      calendars: const [
        GoogleCalendarInfo(
          id: 'me@example.com',
          name: 'Personal',
          color: 0xFF039BE5,
          accessRole: 'owner',
          isPrimary: true,
        ),
      ],
      events: {
        'me@example.com': [
          GoogleEventInfo(
            id: 'e1',
            title: 'Team Meeting',
            start: DateTime(day.year, day.month, day.day, 23, 0),
            end: DateTime(day.year, day.month, day.day, 23, 30),
          ),
          GoogleEventInfo(
            id: 'b1',
            title: "Rahul's birthday",
            start: DateTime(day.year, day.month, day.day),
            end: DateTime(day.year, day.month, day.day + 1),
            isAllDay: true,
            eventType: 'birthday',
          ),
        ],
      },
    );
    await pumpPlanly(
      tester,
      db: db,
      initialLocation: Routes.connect,
      calendarApi: api,
    );

    await tapText(tester, 'Continue with Google');
    await tapText(tester, 'Allow Calendar Access');
    await tapText(tester, 'Continue');

    expect(find.text('You\'re all set!'), findsOneWidget);
    expect(find.text('We found 2 events and 1 birthday.'), findsOneWidget);
    expect(find.text('1 Calendar'), findsOneWidget);

    await tapText(tester, 'Go to My Day');
    expect(find.text('Team Meeting'), findsOneWidget);
    expect(find.text("Rahul's birthday"), findsOneWidget);
    expect(find.textContaining('Synced'), findsOneWidget);
  });

  testWidgets('synced events are stored locally and raise an in-app reminder', (
    tester,
  ) async {
    final db = inMemoryDatabase();
    addTearDown(db.close);
    final start = DateTime.now().add(const Duration(minutes: 5));
    final api = FakeCalendarApi(
      calendars: const [
        GoogleCalendarInfo(
          id: 'me@example.com',
          name: 'Personal',
          color: 0xFF039BE5,
          accessRole: 'owner',
          isPrimary: true,
        ),
      ],
      events: {
        'me@example.com': [
          GoogleEventInfo(
            id: 's1',
            title: 'Standup',
            start: start,
            end: start.add(const Duration(minutes: 15)),
            reminderMinutes: 10,
          ),
        ],
      },
    );
    await pumpPlanly(
      tester,
      db: db,
      initialLocation: Routes.connect,
      calendarApi: api,
    );

    await tapText(tester, 'Continue with Google');
    await tapText(tester, 'Allow Calendar Access');
    await tapText(tester, 'Continue');

    // Saved in the local database with its reminder, marked as shown.
    final row = await tester.runAsync(() => db.select(db.events).getSingle());
    expect(row!.title, 'Standup');
    expect(row.reminderMinutes, 10);
    expect(row.reminderNotifiedAt, isNotNull);

    // The reminder was due (10 min lead, starts in 5): banner is up.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    expect(container.read(reminderSchedulerProvider).single.title, 'Standup');
    expect(find.byKey(const ValueKey('reminder-dismiss')), findsOneWidget);
    expect(find.textContaining('Starts in'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('reminder-dismiss')));
    await settle(tester);
    expect(find.byKey(const ValueKey('reminder-dismiss')), findsNothing);
    expect(container.read(reminderSchedulerProvider), isEmpty);
  });
}
