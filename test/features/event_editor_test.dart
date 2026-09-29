import 'package:event_reminder/app/routes.dart';
import 'package:event_reminder/data/google/google_models.dart';
import 'package:event_reminder/data/google/stub_google_auth_service.dart';
import 'package:event_reminder/data/local/tables/events.dart';
import 'package:event_reminder/data/repositories/account_repository.dart';
import 'package:event_reminder/data/repositories/calendar_repository.dart';
import 'package:event_reminder/data/repositories/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

void main() {
  testWidgets('create event via editor appears on Events and Home', (
    tester,
  ) async {
    final db = inMemoryDatabase();
    addTearDown(db.close);
    await pumpPlanly(tester, db: db, initialLocation: Routes.events);

    await tester.tap(find.byTooltip('Create event'));
    await settle(tester);

    expect(find.text('New event'), findsOneWidget);
    // Wait until the form (not just the app bar) has loaded.
    await tester.pump(const Duration(milliseconds: 50));
    await settle(tester);
    expect(find.byKey(const ValueKey('event-save')), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'What\'s happening?'),
      'Dentist',
    );
    await tester.tap(find.byKey(const ValueKey('event-save')));
    await settle(tester);

    expect(find.text('Dentist'), findsWidgets);

    // Navigate home via bottom nav. IndexedStack keeps other tabs alive, so
    // the title may still appear on the Events stack as well.
    await tester.tap(find.text('Home'));
    await settle(tester);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Dentist'), findsWidgets);
    expect(find.text('Your day is clear'), findsNothing);
  });

  testWidgets('details delete removes a local event', (tester) async {
    final db = inMemoryDatabase();
    addTearDown(db.close);
    final repo = EventRepository(db);
    final id = await repo.create(
      EventDraft(
        title: 'Temp',
        startsAt: DateTime.now().add(const Duration(hours: 2)),
        endsAt: DateTime.now().add(const Duration(hours: 3)),
      ),
    );
    await pumpPlanly(
      tester,
      db: db,
      initialLocation: Routes.eventDetails(id),
    );

    expect(find.text('Temp'), findsOneWidget);
    await tester.tap(find.text('Delete event'));
    await settle(tester);
    await tester.tap(find.text('Delete'));
    await settle(tester);

    expect(await repo.find(id), isNull);
    expect(find.text('My Events'), findsOneWidget);
  });

  testWidgets('editing a synced event marks pending and patches Google', (
    tester,
  ) async {
    final db = inMemoryDatabase();
    addTearDown(db.close);
    const personal = GoogleCalendarInfo(
      id: 'me@example.com',
      name: 'Personal',
      color: 0xFF039BE5,
      accessRole: 'owner',
      isPrimary: true,
    );
    final api = FakeCalendarApi(calendars: const [personal], events: {});
    final accounts = AccountRepository(db);
    await accounts.connect(StubGoogleAuthService.account);
    await accounts.setCalendarAccess(
      StubGoogleAuthService.account.id,
      granted: true,
    );
    final calendars = CalendarRepository(db);
    await calendars.saveSelection(
      StubGoogleAuthService.account.id,
      const [personal],
      {personal.id},
    );
    final calId = (await calendars.selected(
      StubGoogleAuthService.account.id,
    )).single.id;
    final events = EventRepository(db);
    final id = await events.create(
      EventDraft(
        title: 'Standup',
        startsAt: DateTime.now().add(const Duration(hours: 1)),
        endsAt: DateTime.now().add(const Duration(hours: 2)),
        calendarId: calId,
      ),
    );
    await events.markSynced(id, googleEventId: 'g-standup', etag: 'e1');

    await pumpPlanly(
      tester,
      db: db,
      initialLocation: Routes.eventEdit(id),
      calendarApi: api,
    );

    await tester.enterText(find.byType(TextField).first, 'Standup updated');
    await tester.tap(find.byKey(const ValueKey('event-save')));
    await settle(tester);

    // Allow fire-and-forget push to finish.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await settle(tester);

    expect(api.updatedIds, contains('g-standup'));
    final row = await events.find(id);
    expect(row!.title, 'Standup updated');
    expect(row.syncStatus, EventSyncStatus.synced);
  });
}
