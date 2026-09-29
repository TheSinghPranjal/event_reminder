import 'package:drift/drift.dart';

/// Event categories: the built-in set plus user-created custom categories.
@DataClassName('EventCategory')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Stable key for built-in categories (e.g. `birthdays`), used when mapping
  /// imported events to a category. Null for custom categories.
  TextColumn get slug => text().nullable().unique()();

  TextColumn get name => text().withLength(min: 1, max: 40)();

  /// Key into the category icon registry (see `category_icons.dart`).
  TextColumn get iconKey => text()();

  /// ARGB color value.
  IntColumn get color => integer()();

  BoolColumn get isBuiltIn => boolean().withDefault(const Constant(false))();

  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
