import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:event_reminder/data/local/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('upgrades a v1 database (categories only) to v2', () async {
    final db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(
          setup: (raw) {
            // Exact v1 schema, with one custom category the user created.
            raw.execute(
              'CREATE TABLE "categories" ("id" INTEGER NOT NULL PRIMARY KEY '
              'AUTOINCREMENT, "slug" TEXT NULL UNIQUE, "name" TEXT NOT NULL, '
              '"icon_key" TEXT NOT NULL, "color" INTEGER NOT NULL, '
              '"is_built_in" INTEGER NOT NULL DEFAULT 0 CHECK ("is_built_in" '
              'IN (0, 1)), "sort_order" INTEGER NOT NULL DEFAULT 0, '
              '"created_at" TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP))',
            );
            raw.execute(
              "INSERT INTO categories (name, icon_key, color) "
              "VALUES ('Gym', 'fitness', 1)",
            );
            raw.execute('PRAGMA user_version = 1');
          },
        ),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);

    final categories = await db.select(db.categories).get();
    expect(categories.single.name, 'Gym');

    // New tables exist and are usable.
    await db
        .into(db.appSettings)
        .insert(AppSettingsCompanion.insert(key: 'k', value: 'v'));
    expect(await db.select(db.events).get(), isEmpty);
    expect(await db.select(db.calendars).get(), isEmpty);
    expect(await db.select(db.linkedAccounts).get(), isEmpty);
  });
}
