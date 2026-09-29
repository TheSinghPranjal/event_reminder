import 'package:event_reminder/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

void main() {
  testWidgets('five-tab shell navigates and categories load from the DB', (
    tester,
  ) async {
    final db = inMemoryDatabase();
    addTearDown(db.close);
    await pumpPlanly(tester, db: db, initialLocation: Routes.home);

    for (final label in [
      'Home',
      'Calendar',
      'Events',
      'Reminders',
      'Settings',
    ]) {
      expect(find.text(label), findsWidgets);
    }
    expect(find.text('Your day is clear'), findsOneWidget);
    expect(find.text('Connect Google Calendar'), findsOneWidget);

    await tester.tap(find.text('Reminders'));
    await settle(tester);
    expect(find.text('Nothing to remind you about yet.'), findsOneWidget);

    await tester.tap(find.text('Events'));
    await settle(tester);
    expect(find.text('No events yet'), findsOneWidget);
    await tester.tap(find.byTooltip('Create event'));
    await settle(tester);
    expect(find.text('New event'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded));
    await settle(tester);

    await tester.tap(find.text('Settings'));
    await settle(tester);
    await tester.tap(find.text('Categories'));
    await settle(tester);

    expect(find.text('Event Categories'), findsOneWidget);
    expect(find.text('Meetings'), findsOneWidget);
  });
}
