import 'package:drift/drift.dart';

import '../google/google_models.dart';
import '../local/app_database.dart';
import 'settings_repository.dart';

class AccountRepository {
  AccountRepository(this._db);

  final AppDatabase _db;

  /// Stores [account] and makes it the active account.
  Future<void> connect(GoogleAccountInfo account) {
    return _db.transaction(() async {
      await _db
          .into(_db.linkedAccounts)
          .insert(
            LinkedAccountsCompanion.insert(
              id: account.id,
              email: account.email,
              displayName: Value(account.displayName),
              photoUrl: Value(account.photoUrl),
              isStub: Value(account.isStub),
            ),
            onConflict: DoUpdate(
              (_) => LinkedAccountsCompanion(
                email: Value(account.email),
                displayName: Value(account.displayName),
                photoUrl: Value(account.photoUrl),
                isStub: Value(account.isStub),
              ),
            ),
          );
      await _db
          .into(_db.appSettings)
          .insertOnConflictUpdate(
            AppSettingsCompanion.insert(
              key: SettingKeys.activeAccountId,
              value: account.id,
            ),
          );
    });
  }

  Future<LinkedAccount?> find(String id) {
    return (_db.select(
      _db.linkedAccounts,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
  }

  Stream<LinkedAccount?> watchActive() {
    final query = _db.select(_db.linkedAccounts).join([
      innerJoin(
        _db.appSettings,
        _db.appSettings.key.equals(SettingKeys.activeAccountId) &
            _db.appSettings.value.equalsExp(_db.linkedAccounts.id),
      ),
    ]);
    return query.watchSingleOrNull().map(
      (row) => row?.readTable(_db.linkedAccounts),
    );
  }

  Future<void> setCalendarAccess(String id, {required bool granted}) {
    return (_db.update(_db.linkedAccounts)..where((a) => a.id.equals(id)))
        .write(LinkedAccountsCompanion(calendarAccessGranted: Value(granted)));
  }

  Future<void> recordSyncSuccess(String id, DateTime at) {
    return (_db.update(
      _db.linkedAccounts,
    )..where((a) => a.id.equals(id))).write(
      LinkedAccountsCompanion(
        lastSyncSuccessAt: Value(at),
        lastSyncAttemptAt: Value(at),
        lastSyncError: const Value(null),
      ),
    );
  }

  Future<void> recordSyncFailure(String id, DateTime at, String message) {
    return (_db.update(
      _db.linkedAccounts,
    )..where((a) => a.id.equals(id))).write(
      LinkedAccountsCompanion(
        lastSyncAttemptAt: Value(at),
        lastSyncError: Value(message),
      ),
    );
  }
}
