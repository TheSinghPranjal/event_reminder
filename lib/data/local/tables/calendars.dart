import 'package:drift/drift.dart';

import 'linked_accounts.dart';

/// Calendars available on a linked Google account.
@DataClassName('SyncedCalendar')
class Calendars extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get accountId =>
      text().references(LinkedAccounts, #id, onDelete: KeyAction.cascade)();

  /// Google Calendar ID (e.g. `primary@gmail.com`).
  TextColumn get googleCalendarId => text()();
  TextColumn get name => text()();

  /// Google's background color for the calendar (ARGB).
  IntColumn get color => integer()();

  /// Google access role: owner, writer, reader or freeBusyReader.
  TextColumn get accessRole => text()();
  BoolColumn get isPrimary => boolean().withDefault(const Constant(false))();

  /// Chosen for sync by the user.
  BoolColumn get isSelected => boolean().withDefault(const Constant(false))();

  /// Shown in calendar views (filters can hide a synced calendar).
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();

  /// Incremental sync token from the Google Calendar API.
  TextColumn get syncToken => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {accountId, googleCalendarId},
  ];
}
