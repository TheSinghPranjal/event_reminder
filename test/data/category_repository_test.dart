import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:event_reminder/data/local/app_database.dart';
import 'package:event_reminder/data/local/default_categories.dart';
import 'package:event_reminder/data/repositories/category_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late CategoryRepository repo;

  setUp(() {
    db = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    repo = CategoryRepository(db);
  });

  tearDown(() => db.close());

  test('seeds built-in categories in order on first open', () async {
    final all = await repo.watchAll().first;
    expect(all.map((c) => c.slug), defaultCategories.map((c) => c.slug));
    expect(all.every((c) => c.isBuiltIn), isTrue);
  });

  test('creates custom categories after the built-ins', () async {
    await repo.createCustom(name: '  Gym  ', iconKey: 'fitness', color: 1);
    final all = await repo.watchAll().first;
    expect(all.last.name, 'Gym');
    expect(all.last.slug, isNull);
    expect(all.last.isBuiltIn, isFalse);
  });

  test('rejects empty names', () {
    expect(
      () => repo.createCustom(name: '   ', iconKey: 'star', color: 1),
      throwsArgumentError,
    );
  });

  test('deletes custom categories but never built-ins', () async {
    final id = await repo.createCustom(name: 'Gym', iconKey: 'star', color: 1);
    final birthdays = await repo.findBySlug('birthdays');

    expect(await repo.deleteCustom(birthdays!.id), isFalse);
    expect(await repo.deleteCustom(id), isTrue);
    expect(await repo.findBySlug('birthdays'), isNotNull);
  });
}
