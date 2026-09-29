import 'package:drift/drift.dart';

/// A Google account the user connected. Sync state lives here so the UI can
/// show real "last synced" information.
@DataClassName('LinkedAccount')
class LinkedAccounts extends Table {
  /// Google account (subject) ID.
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get displayName => text().nullable()();
  TextColumn get photoUrl => text().nullable()();

  /// True when the account came from the developer stub, not real Google.
  BoolColumn get isStub => boolean().withDefault(const Constant(false))();

  /// Calendar access is authorized separately from sign-in.
  BoolColumn get calendarAccessGranted =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get connectedAt =>
      dateTime().withDefault(currentDateAndTime)();

  /// Last time a sync finished successfully.
  DateTimeColumn get lastSyncSuccessAt => dateTime().nullable()();

  /// Last attempt (successful or not), with its outcome.
  DateTimeColumn get lastSyncAttemptAt => dateTime().nullable()();
  TextColumn get lastSyncError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
