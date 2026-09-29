import 'package:drift/drift.dart';

import '../google/google_models.dart';
import '../local/app_database.dart';
import '../local/tables/events.dart';

/// An event with the calendar and category it belongs to, for display.
class EventView {
  const EventView(this.event, this.calendar, this.category);

  final CalendarEvent event;
  final SyncedCalendar? calendar;
  final EventCategory? category;

  bool get isBirthday => event.eventType == 'birthday';
}

/// Fields for creating or updating a local event.
class EventDraft {
  const EventDraft({
    required this.title,
    required this.startsAt,
    required this.endsAt,
    this.isAllDay = false,
    this.description,
    this.location,
    this.reminderMinutes,
    this.categoryId,
    this.calendarId,
  });

  final String title;
  final DateTime startsAt;
  final DateTime endsAt;
  final bool isAllDay;
  final String? description;
  final String? location;
  final int? reminderMinutes;
  final int? categoryId;

  /// Null = local-only event (never pushed to Google).
  final int? calendarId;
}

class EventRepository {
  EventRepository(this._db);

  final AppDatabase _db;

  Expression<bool> get _notPendingDelete =>
      _db.events.syncStatus.isNotValue(EventSyncStatus.pendingDelete);

  Future<CalendarEvent?> find(int id) {
    return (_db.select(
      _db.events,
    )..where((e) => e.id.equals(id))).getSingleOrNull();
  }

  Stream<CalendarEvent?> watch(int id) {
    return (_db.select(
      _db.events,
    )..where((e) => e.id.equals(id))).watchSingleOrNull();
  }

  Stream<EventView?> watchView(int id) {
    final e = _db.events;
    final c = _db.calendars;
    final query = _db.select(e).join([
      leftOuterJoin(c, c.id.equalsExp(e.calendarId)),
      leftOuterJoin(_db.categories, _db.categories.id.equalsExp(e.categoryId)),
    ])..where(e.id.equals(id));
    return query.watchSingleOrNull().map((row) {
      if (row == null) return null;
      return EventView(
        row.readTable(e),
        row.readTableOrNull(c),
        row.readTableOrNull(_db.categories),
      );
    });
  }

  /// Creates a local or pending-create event. Returns the new row id.
  Future<int> create(EventDraft draft) {
    final status = draft.calendarId == null
        ? EventSyncStatus.local
        : EventSyncStatus.pendingCreate;
    return _db
        .into(_db.events)
        .insert(
          EventsCompanion.insert(
            calendarId: Value(draft.calendarId),
            title: draft.title,
            description: Value(draft.description),
            location: Value(draft.location),
            startsAt: draft.startsAt,
            endsAt: draft.endsAt,
            isAllDay: Value(draft.isAllDay),
            reminderMinutes: Value(draft.reminderMinutes),
            categoryId: Value(draft.categoryId),
            syncStatus: Value(status),
          ),
        );
  }

  /// Updates fields and sets the appropriate pending sync status.
  Future<void> update(int id, EventDraft draft) async {
    final existing = await find(id);
    if (existing == null) return;

    final String status;
    if (draft.calendarId == null && existing.googleEventId == null) {
      status = EventSyncStatus.local;
    } else if (existing.syncStatus == EventSyncStatus.pendingCreate ||
        existing.googleEventId == null) {
      status = EventSyncStatus.pendingCreate;
    } else if (existing.syncStatus == EventSyncStatus.local) {
      status = EventSyncStatus.local;
    } else {
      status = EventSyncStatus.pendingUpdate;
    }

    await (_db.update(_db.events)..where((e) => e.id.equals(id))).write(
      EventsCompanion(
        calendarId: Value(draft.calendarId),
        title: Value(draft.title),
        description: Value(draft.description),
        location: Value(draft.location),
        startsAt: Value(draft.startsAt),
        endsAt: Value(draft.endsAt),
        isAllDay: Value(draft.isAllDay),
        reminderMinutes: Value(draft.reminderMinutes),
        categoryId: Value(draft.categoryId),
        syncStatus: Value(status),
        syncError: const Value(null),
        // Re-arm reminder if fire time moved.
        reminderNotifiedAt:
            existing.startsAt == draft.startsAt &&
                existing.reminderMinutes == draft.reminderMinutes
            ? const Value.absent()
            : const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Soft-deletes (pendingDelete) synced events; hard-deletes local / unpushed.
  Future<void> delete(int id) async {
    final existing = await find(id);
    if (existing == null) return;
    if (existing.syncStatus == EventSyncStatus.local ||
        existing.syncStatus == EventSyncStatus.pendingCreate ||
        existing.googleEventId == null) {
      await (_db.delete(_db.events)..where((e) => e.id.equals(id))).go();
      return;
    }
    await (_db.update(_db.events)..where((e) => e.id.equals(id))).write(
      EventsCompanion(
        syncStatus: const Value(EventSyncStatus.pendingDelete),
        syncError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Rows waiting to be pushed for calendars belonging to [accountId].
  Future<List<CalendarEvent>> pendingFor(String accountId) {
    final e = _db.events;
    final c = _db.calendars;
    final query =
        _db.select(e).join([
            innerJoin(c, c.id.equalsExp(e.calendarId)),
          ])
          ..where(
            c.accountId.equals(accountId) &
                e.syncStatus.isIn([
                  EventSyncStatus.pendingCreate,
                  EventSyncStatus.pendingUpdate,
                  EventSyncStatus.pendingDelete,
                  EventSyncStatus.failed,
                ]),
          )
          ..orderBy([OrderingTerm(expression: e.updatedAt)]);
    return query.map((r) => r.readTable(e)).get();
  }

  Future<void> markSynced(int id, {String? googleEventId, String? etag}) {
    return (_db.update(_db.events)..where((e) => e.id.equals(id))).write(
      EventsCompanion(
        googleEventId: googleEventId != null
            ? Value(googleEventId)
            : const Value.absent(),
        etag: Value(etag),
        syncStatus: const Value(EventSyncStatus.synced),
        syncError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Hard-delete after a successful remote delete push.
  Future<void> hardDelete(int id) {
    return (_db.delete(_db.events)..where((e) => e.id.equals(id))).go();
  }

  Future<void> markFailed(int id, String message) {
    return (_db.update(_db.events)..where((e) => e.id.equals(id))).write(
      EventsCompanion(
        syncStatus: const Value(EventSyncStatus.failed),
        syncError: Value(message),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Records a push error without changing [syncStatus] (e.g. pendingDelete).
  Future<void> markSyncError(int id, String message) {
    return (_db.update(_db.events)..where((e) => e.id.equals(id))).write(
      EventsCompanion(
        syncError: Value(message),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Applies a remote page: upserts non-cancelled events (skipping local
  /// pending rows), hard-deletes cancelled ids that aren't pending.
  Future<int> applyRemoteDelta(int calendarId, GoogleEventPage page) async {
    final now = DateTime.now();
    var written = 0;

    // Skip remote updates for rows that still have local pending changes.
    final pendingGoogleIds =
        await (_db.select(_db.events)..where(
              (e) =>
                  e.calendarId.equals(calendarId) &
                  e.googleEventId.isNotNull() &
                  e.syncStatus.isIn(EventSyncStatus.pending.toList()),
            ))
            .get()
            .then(
              (rows) => {
                for (final r in rows)
                  if (r.googleEventId != null) r.googleEventId!,
              },
            );

    await _db.batch((b) {
      for (final e in page.events) {
        if (e.isCancelled) continue;
        if (pendingGoogleIds.contains(e.id)) continue;
        written++;
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
            reminderMinutes: Value(e.reminderMinutes),
            etag: Value(e.etag),
            syncStatus: const Value(EventSyncStatus.synced),
          ),
          onConflict: DoUpdate(
            ($EventsTable old) => EventsCompanion.custom(
              title: Variable(e.title),
              description: Variable(e.description),
              location: Variable(e.location),
              startsAt: Variable(e.start),
              endsAt: Variable(e.end),
              isAllDay: Variable(e.isAllDay),
              eventType: Variable(e.eventType),
              reminderMinutes: Variable(e.reminderMinutes),
              etag: Variable(e.etag),
              syncStatus: const Constant(EventSyncStatus.synced),
              syncError: const Constant(null),
              reminderNotifiedAt: CaseWhenExpression(
                cases: [
                  CaseWhen(
                    old.startsAt.equals(e.start) &
                        old.reminderMinutes.equalsNullable(e.reminderMinutes),
                    then: old.reminderNotifiedAt,
                  ),
                ],
                orElse: const Constant<DateTime>(null),
              ),
              updatedAt: Variable(now),
            ),
            target: [_db.events.calendarId, _db.events.googleEventId],
          ),
        );
      }
    });

    for (final cancelledId in page.cancelledIds) {
      if (pendingGoogleIds.contains(cancelledId)) continue;
      await (_db.delete(_db.events)..where(
            (e) =>
                e.calendarId.equals(calendarId) &
                e.googleEventId.equals(cancelledId) &
                e.syncStatus.isNotIn(EventSyncStatus.pending.toList()),
          ))
          .go();
    }

    return written;
  }

  /// Legacy name kept for callers that still pass a flat list.
  Future<int> upsertGoogleEvents(
    int calendarId,
    List<GoogleEventInfo> events,
  ) {
    return applyRemoteDelta(
      calendarId,
      GoogleEventPage(events: events),
    );
  }

  /// Events with a reminder that hasn't been shown yet and that haven't
  /// started before [after], soonest start first.
  Stream<List<CalendarEvent>> watchPendingReminders(DateTime after) {
    final e = _db.events;
    final c = _db.calendars;
    final query =
        _db.select(e).join([leftOuterJoin(c, c.id.equalsExp(e.calendarId))])
          ..where(
            e.reminderMinutes.isNotNull() &
                e.reminderNotifiedAt.isNull() &
                e.startsAt.isBiggerThanValue(after) &
                _notPendingDelete &
                (e.calendarId.isNull() | (c.isSelected & c.isVisible)),
          )
          ..orderBy([OrderingTerm(expression: e.startsAt)]);
    return query.watch().map((rows) => [for (final r in rows) r.readTable(e)]);
  }

  Future<void> markReminderNotified(int eventId, DateTime at) {
    return (_db.update(_db.events)..where((e) => e.id.equals(eventId))).write(
      EventsCompanion(reminderNotifiedAt: Value(at)),
    );
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
              e.categoryId.isNull() &
              _notPendingDelete,
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
      ..where(_inAccount(_db.events, accountId) & _notPendingDelete);
    if (birthdaysOnly) query.where(_db.events.eventType.equals('birthday'));
    return (await query.map((r) => r.read(count)).getSingle()) ?? 0;
  }

  /// Event count per selected calendar of [accountId].
  Future<Map<SyncedCalendar, int>> countsByCalendar(String accountId) async {
    final count = _db.events.id.count(
      filter: _db.events.syncStatus.isNotValue(EventSyncStatus.pendingDelete),
    );
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
                _notPendingDelete &
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

  /// Upcoming (and in-progress) events from [from] onward, soonest first.
  Stream<List<EventView>> watchUpcoming(DateTime from) {
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
            e.endsAt.isBiggerThanValue(from) &
                _notPendingDelete &
                (e.calendarId.isNull() | (c.isSelected & c.isVisible)),
          )
          ..orderBy([OrderingTerm(expression: e.startsAt)]);
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
