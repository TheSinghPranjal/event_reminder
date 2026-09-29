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

  test('upgrades a v3 database by adding sync columns', () async {
    final db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(
          setup: (raw) {
            raw.execute(
              'CREATE TABLE "categories" ("id" INTEGER NOT NULL PRIMARY KEY '
              'AUTOINCREMENT, "slug" TEXT NULL UNIQUE, "name" TEXT NOT NULL, '
              '"icon_key" TEXT NOT NULL, "color" INTEGER NOT NULL, '
              '"is_built_in" INTEGER NOT NULL DEFAULT 0 CHECK ("is_built_in" '
              'IN (0, 1)), "sort_order" INTEGER NOT NULL DEFAULT 0, '
              '"created_at" TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP))',
            );
            raw.execute(
              'CREATE TABLE IF NOT EXISTS "app_settings" ("key" TEXT NOT NULL '
              'PRIMARY KEY, "value" TEXT NOT NULL)',
            );
            raw.execute(
              'CREATE TABLE IF NOT EXISTS "linked_accounts" ('
              '"id" TEXT NOT NULL PRIMARY KEY, "email" TEXT NOT NULL, '
              '"display_name" TEXT NULL, "photo_url" TEXT NULL, '
              '"is_stub" INTEGER NOT NULL DEFAULT 0 CHECK ("is_stub" IN (0, 1)), '
              '"calendar_access_granted" INTEGER NOT NULL DEFAULT 0 '
              'CHECK ("calendar_access_granted" IN (0, 1)), '
              '"connected_at" TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP), '
              '"last_sync_success_at" TEXT NULL, '
              '"last_sync_attempt_at" TEXT NULL, '
              '"last_sync_error" TEXT NULL)',
            );
            raw.execute(
              'CREATE TABLE IF NOT EXISTS "calendars" ('
              '"id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
              '"account_id" TEXT NOT NULL REFERENCES "linked_accounts" ("id") '
              'ON DELETE CASCADE, "google_calendar_id" TEXT NOT NULL, '
              '"name" TEXT NOT NULL, "color" INTEGER NOT NULL, '
              '"access_role" TEXT NOT NULL, '
              '"is_primary" INTEGER NOT NULL DEFAULT 0 CHECK ("is_primary" IN (0, 1)), '
              '"is_selected" INTEGER NOT NULL DEFAULT 0 CHECK ("is_selected" IN (0, 1)), '
              '"is_visible" INTEGER NOT NULL DEFAULT 1 CHECK ("is_visible" IN (0, 1)), '
              '"sync_token" TEXT NULL, '
              'UNIQUE ("account_id", "google_calendar_id"))',
            );
            raw.execute(
              'CREATE TABLE IF NOT EXISTS "events" ('
              '"id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, '
              '"calendar_id" INTEGER NULL REFERENCES "calendars" ("id") '
              'ON DELETE CASCADE, "google_event_id" TEXT NULL, '
              '"title" TEXT NOT NULL, "description" TEXT NULL, '
              '"location" TEXT NULL, "starts_at" TEXT NOT NULL, '
              '"ends_at" TEXT NOT NULL, '
              '"is_all_day" INTEGER NOT NULL DEFAULT 0 CHECK ("is_all_day" IN (0, 1)), '
              '"event_type" TEXT NOT NULL DEFAULT \'default\', '
              '"reminder_minutes" INTEGER NULL, '
              '"reminder_notified_at" TEXT NULL, '
              '"category_id" INTEGER NULL REFERENCES "categories" ("id") '
              'ON DELETE SET NULL, '
              '"created_at" TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP), '
              '"updated_at" TEXT NOT NULL DEFAULT (CURRENT_TIMESTAMP), '
              'UNIQUE ("calendar_id", "google_event_id"))',
            );
            raw.execute(
              "INSERT INTO events (title, starts_at, ends_at) "
              "VALUES ('Legacy', '2026-01-01T00:00:00.000', "
              "'2026-01-01T01:00:00.000')",
            );
            raw.execute('PRAGMA user_version = 3');
          },
        ),
        closeStreamsSynchronously: true,
      ),
    );
    addTearDown(db.close);

    final row = await db.select(db.events).getSingle();
    expect(row.title, 'Legacy');
    expect(row.syncStatus, 'synced');
    expect(row.etag, equals(null));
    expect(row.syncError, equals(null));
  });
}
