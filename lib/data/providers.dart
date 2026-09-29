import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local/app_database.dart';
import 'repositories/category_repository.dart';

/// Single app-wide database. Override in tests with an in-memory instance.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(ref.watch(appDatabaseProvider)),
);
