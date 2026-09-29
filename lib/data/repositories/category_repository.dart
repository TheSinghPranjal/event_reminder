import 'package:drift/drift.dart';

import '../local/app_database.dart';

class CategoryRepository {
  CategoryRepository(this._db);

  final AppDatabase _db;

  Stream<List<EventCategory>> watchAll() {
    return (_db.select(_db.categories)..orderBy([
          (c) => OrderingTerm(expression: c.sortOrder),
          (c) => OrderingTerm(expression: c.id),
        ]))
        .watch();
  }

  Future<EventCategory?> findBySlug(String slug) {
    return (_db.select(
      _db.categories,
    )..where((c) => c.slug.equals(slug))).getSingleOrNull();
  }

  /// Creates a custom category, placed after all existing ones.
  Future<int> createCustom({
    required String name,
    required String iconKey,
    required int color,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
    final maxOrder = _db.categories.sortOrder.max();
    final last = await (_db.selectOnly(
      _db.categories,
    )..addColumns([maxOrder])).map((r) => r.read(maxOrder)).getSingle();

    return _db
        .into(_db.categories)
        .insert(
          CategoriesCompanion.insert(
            name: trimmed,
            iconKey: iconKey,
            color: color,
            sortOrder: Value((last ?? -1) + 1),
          ),
        );
  }

  /// Built-in categories can't be deleted; returns false if nothing was removed.
  Future<bool> deleteCustom(int id) async {
    final removed = await (_db.delete(
      _db.categories,
    )..where((c) => c.id.equals(id) & c.isBuiltIn.equals(false))).go();
    return removed > 0;
  }
}
