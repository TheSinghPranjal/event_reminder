import 'package:drift/drift.dart';

import '../google/google_models.dart';
import '../local/app_database.dart';

/// An event with the calendar and category it belongs to, for display.
class EventView {
  const EventView(this.event, this.calendar, this.category);

  final CalendarEvent event;
  final SyncedCalendar? calendar;
  final EventCategory? category;

  bool get isBirthday => event.eventType == 'birthday';
}

class EventRepository {
  EventRepository(this._db);

  final AppDatabase _db;

  /// Inserts or updates [events] for the calendar row [calendarId].
  /// Returns how many events were written.
  Future<int> upsertGoogleEvents(
    int calendarId,
    List<GoogleEventInfo> events,
  ) async {
    final now = DateTime.now();
    await _db.batch((b) {
      for (final e in events) {
        b.insert(
          _db.events,
          EventsCompanion.insert(
            calendarId: Value(calendarId),
            googleEventId: Value(e.id),
            title: e.title,
            description: Value(e.description),
            location: Value(e.location),
            startsAt: e.start,
            endsAt: e.end,
            isAllDay: Value(e.isAllDay),
            eventType: Value(e.eventType),
          ),
          onConflict: DoUpdate(
            (_) => EventsCompanion(
              title: Value(e.title),
              description: Value(e.description),
              location: Value(e.location),
              startsAt: Value(e.start),
              endsAt: Value(e.end),
              isAllDay: Value(e.isAllDay),
              eventType: Value(e.eventType),
              updatedAt: Value(now),
            ),
            target: [_db.events.calendarId, _db.events.googleEventId],
          ),
        );
      }
    });
    return events.length;
  }

  Expression<bool> _inAccount($EventsTable e, String accountId) {
    final ids = _db.selectOnly(_db.calendars)
      ..addColumns([_db.calendars.id])
      ..where(_db.calendars.accountId.equals(accountId));
    return e.calendarId.isInQuery(ids);
  }

  /// Puts every birthday-type event of [accountId] into [categoryId]
  /// (unless the user already chose a category). Returns the birthday count.
  Future<int> categorizeBirthdays(String accountId, int categoryId) async {
    await (_db.update(_db.events)..where(
          (e) =>
              _inAccount(e, accountId) &
              e.eventType.equals('birthday') &
              e.categoryId.isNull(),
        ))
        .write(EventsCompanion(categoryId: Value(categoryId)));
    return countForAccount(accountId, birthdaysOnly: true);
  }

  Future<int> countForAccount(
    String accountId, {
    bool birthdaysOnly = false,
  }) async {
    final count = _db.events.id.count();
    final query = _db.selectOnly(_db.events)
      ..addColumns([count])
      ..where(_inAccount(_db.events, accountId));
    if (birthdaysOnly) query.where(_db.events.eventType.equals('birthday'));
    return (await query.map((r) => r.read(count)).getSingle()) ?? 0;
  }

  /// Event count per selected calendar of [accountId].
  Future<Map<SyncedCalendar, int>> countsByCalendar(String accountId) async {
    final count = _db.events.id.count();
    final query =
        _db.select(_db.calendars).join([
            leftOuterJoin(
              _db.events,
              _db.events.calendarId.equalsExp(_db.calendars.id),
            ),
          ])
          ..addColumns([count])
          ..where(
            _db.calendars.accountId.equals(accountId) &
                _db.calendars.isSelected,
          )
          ..groupBy([_db.calendars.id])
          ..orderBy([OrderingTerm.desc(_db.calendars.isPrimary)]);
    final rows = await query.get();
    return {
      for (final r in rows) r.readTable(_db.calendars): r.read(count) ?? 0,
    };
  }

  /// Events overlapping [start, end) from visible, selected calendars or
  /// local-only events, all-day first then by start time.
  Stream<List<EventView>> watchBetween(DateTime start, DateTime end) {
    final e = _db.events;
    final c = _db.calendars;
    final query =
        _db.select(e).join([
            leftOuterJoin(c, c.id.equalsExp(e.calendarId)),
            leftOuterJoin(
              _db.categories,
              _db.categories.id.equalsExp(e.categoryId),
            ),
          ])
          ..where(
            e.startsAt.isSmallerThanValue(end) &
                e.endsAt.isBiggerThanValue(start) &
                (e.calendarId.isNull() | (c.isSelected & c.isVisible)),
          )
          ..orderBy([
            OrderingTerm.desc(e.isAllDay),
            OrderingTerm(expression: e.startsAt),
          ]);
    return query.watch().map(
      (rows) => [
        for (final r in rows)
          EventView(
            r.readTable(e),
            r.readTableOrNull(c),
            r.readTableOrNull(_db.categories),
          ),
      ],
    );
  }
}
