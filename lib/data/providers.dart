import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'google/google_auth_service.dart';
import 'google/google_calendar_api.dart';
import 'google/stub_google_auth_service.dart';
import 'google/stub_google_calendar_api.dart';
import 'local/app_database.dart';
import 'repositories/account_repository.dart';
import 'repositories/calendar_repository.dart';
import 'repositories/category_repository.dart';
import 'repositories/event_repository.dart';
import 'repositories/settings_repository.dart';

/// Single app-wide database. Override in tests with an in-memory instance.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(ref.watch(appDatabaseProvider)),
);

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(appDatabaseProvider)),
);

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(ref.watch(appDatabaseProvider)),
);

final calendarRepositoryProvider = Provider<CalendarRepository>(
  (ref) => CalendarRepository(ref.watch(appDatabaseProvider)),
);

final eventRepositoryProvider = Provider<EventRepository>(
  (ref) => EventRepository(ref.watch(appDatabaseProvider)),
);

/// Google Sign-In. Currently the developer stub (see phase 7 of the plan).
final googleAuthServiceProvider = Provider<GoogleAuthService>(
  (ref) => const StubGoogleAuthService(),
);

/// Google Calendar API. Currently the developer stub.
final googleCalendarApiProvider = Provider<GoogleCalendarApi>(
  (ref) => const StubGoogleCalendarApi(),
);
