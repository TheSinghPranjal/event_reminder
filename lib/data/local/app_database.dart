import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'default_categories.dart';
import 'tables/categories.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Categories])
class AppDatabase extends _$AppDatabase {
  /// Pass an [executor] in tests (e.g. `NativeDatabase.memory()`).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openDefault());

  static QueryExecutor _openDefault() => driftDatabase(name: 'planly');

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedDefaultCategories();
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
