import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/event_repository.dart';
import '../sync/providers/account_providers.dart';

final upcomingEventsProvider = StreamProvider.autoDispose<List<EventView>>(
  (ref) => ref.watch(eventRepositoryProvider).watchUpcoming(DateTime.now()),
);

final eventViewProvider = StreamProvider.autoDispose.family<EventView?, int>(
  (ref, id) => ref.watch(eventRepositoryProvider).watchView(id),
);

/// Writable synced calendars for the active Google account (empty if none).
final writableCalendarsProvider =
    FutureProvider.autoDispose<List<SyncedCalendar>>((ref) async {
      final account = await ref.watch(activeAccountProvider.future);
      if (account == null || !account.calendarAccessGranted) return const [];
      return ref.watch(calendarRepositoryProvider).writableFor(account.id);
    });
