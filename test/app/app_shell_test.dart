import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:event_reminder/app/app.dart';
import 'package:event_reminder/data/local/app_database.dart';
import 'package:event_reminder/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('five-tab shell navigates and categories load from the DB', (
    tester,
  ) async {
    final db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const PlanlyApp(),
      ),
    );
    await tester.pumpAndSettle();

    for (final label in [
      'Home',
      'Calendar',
      'Events',
      'Reminders',
      'Settings',
    ]) {
      expect(find.text(label), findsWidgets);
    }

    await tester.tap(find.text('Reminders'));
    await tester.pumpAndSettle();
    expect(find.text('Nothing to remind you about yet.'), findsOneWidget);

    await tester.tap(find.text('Events'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Browse categories'));
    // Drift queries complete on a real async boundary.
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.text('Event Categories'), findsOneWidget);
    expect(find.text('Meetings'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
