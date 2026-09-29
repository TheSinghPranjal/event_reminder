import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'default_categories.dart';
import 'tables/app_settings.dart';
import 'tables/calendars.dart';
import 'tables/categories.dart';
import 'tables/events.dart';
import 'tables/linked_accounts.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Categories, AppSettings, LinkedAccounts, Calendars, Events],
)
class AppDatabase extends _$AppDatabase {
  /// Pass an [executor] in tests (e.g. `NativeDatabase.memory()`).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openDefault());

  static QueryExecutor _openDefault() => driftDatabase(name: 'planly');

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedDefaultCategories();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(appSettings);
        await m.createTable(linkedAccounts);
        await m.createTable(calendars);
        await m.createTable(events);
      } else if (from < 3) {
        await m.addColumn(events, events.reminderMinutes);
        await m.addColumn(events, events.reminderNotifiedAt);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<void> _seedDefaultCategories() async {
    await batch((b) {
      b.insertAll(categories, [
        for (final (i, c) in defaultCategories.indexed)
          CategoriesCompanion.insert(
            slug: Value(c.slug),
            name: c.name,
            iconKey: c.iconKey,
            color: c.color,
            isBuiltIn: const Value(true),
            sortOrder: Value(i),
          ),
      ]);
    });
  }
}
