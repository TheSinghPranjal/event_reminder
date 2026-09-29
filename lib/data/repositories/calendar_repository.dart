import 'package:drift/drift.dart';

import '../google/google_models.dart';
import '../local/app_database.dart';

class CalendarRepository {
  CalendarRepository(this._db);

  final AppDatabase _db;

  /// Upserts every calendar in [available] for [accountId] and marks exactly
  /// the ones in [selectedIds] (Google calendar IDs) as selected for sync.
  Future<void> saveSelection(
    String accountId,
    List<GoogleCalendarInfo> available,
    Set<String> selectedIds,
  ) {
    return _db.transaction(() async {
      await refreshMetadata(accountId, available);
      await (_db.update(_db.calendars)
            ..where((c) => c.accountId.equals(accountId)))
          .write(const CalendarsCompanion(isSelected: Value(false)));
      await (_db.update(_db.calendars)..where(
            (c) =>
                c.accountId.equals(accountId) &
                c.googleCalendarId.isIn(selectedIds),
          ))
          .write(const CalendarsCompanion(isSelected: Value(true)));
    });
  }

  /// Inserts new calendars and updates name/color/role of known ones,
  /// without touching the user's selection.
  Future<void> refreshMetadata(
    String accountId,
    List<GoogleCalendarInfo> available,
  ) async {
    await _db.batch((b) {
      for (final c in available) {
        b.insert(
          _db.calendars,
          CalendarsCompanion.insert(
            accountId: accountId,
            googleCalendarId: c.id,
            name: c.name,
            color: c.color,
            accessRole: c.accessRole,
            isPrimary: Value(c.isPrimary),
          ),
          onConflict: DoUpdate(
            (_) => CalendarsCompanion(
              name: Value(c.name),
              color: Value(c.color),
              accessRole: Value(c.accessRole),
              isPrimary: Value(c.isPrimary),
            ),
            target: [_db.calendars.accountId, _db.calendars.googleCalendarId],
          ),
        );
      }
    });
  }

  Future<List<SyncedCalendar>> selected(String accountId) {
    return (_db.select(_db.calendars)
          ..where((c) => c.accountId.equals(accountId) & c.isSelected)
          ..orderBy([
            (c) => OrderingTerm.desc(c.isPrimary),
            (c) => OrderingTerm(expression: c.name),
          ]))
        .get();
  }
}
