import '../local/app_database.dart';

abstract final class SettingKeys {
  static const onboardingCompleted = 'onboarding_completed';
  static const activeAccountId = 'active_account_id';
}

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Future<String?> read(String key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> write(String key, String value) {
    return _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<void> remove(String key) {
    return (_db.delete(_db.appSettings)..where((s) => s.key.equals(key))).go();
  }

  Future<bool> isOnboardingCompleted() async =>
      await read(SettingKeys.onboardingCompleted) == 'true';

  Future<void> markOnboardingCompleted() =>
      write(SettingKeys.onboardingCompleted, 'true');
}
