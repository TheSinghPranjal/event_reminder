import 'package:drift/drift.dart';

/// Small key/value store for app-level flags (onboarding state, active account).
class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
