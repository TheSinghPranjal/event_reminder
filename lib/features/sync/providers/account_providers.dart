import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../../../data/providers.dart';

/// The connected Google account, or null when using Planly without Google.
final activeAccountProvider = StreamProvider<LinkedAccount?>(
  (ref) => ref.watch(accountRepositoryProvider).watchActive(),
);
