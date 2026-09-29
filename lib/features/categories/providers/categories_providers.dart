import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/providers.dart';

final categoriesProvider = StreamProvider<List<EventCategory>>(
  (ref) => ref.watch(categoryRepositoryProvider).watchAll(),
);
