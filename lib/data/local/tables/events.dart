import 'package:drift/drift.dart';

import 'calendars.dart';
import 'categories.dart';

/// Sync lifecycle for a local event row.
///
/// - `local` — never destined for Google
/// - `synced` — matches Google (or just imported)
/// - `pendingCreate` / `pendingUpdate` / `pendingDelete` — awaiting push
/// - `failed` — last push attempt failed ([Events.syncError] has the message)
abstract final class EventSyncStatus {
  static const local = 'local';
  static const synced = 'synced';
  static const pendingCreate = 'pendingCreate';
  static const pendingUpdate = 'pendingUpdate';
  static const pendingDelete = 'pendingDelete';
  static const failed = 'failed';

  static const pending = {pendingCreate, pendingUpdate, pendingDelete, failed};
}

/// Calendar events, both imported from Google and created locally.
@DataClassName('CalendarEvent')
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Null for local-only events.
  IntColumn get calendarId => integer().nullable().references(
    Calendars,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// Google event ID; together with [calendarId] (which belongs to one
  /// account) this identifies a synced event.
  TextColumn get googleEventId => text().nullable()();

  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get location => text().nullable()();

  DateTimeColumn get startsAt => dateTime()();
  DateTimeColumn get endsAt => dateTime()();

  /// All-day events have no meaningful time; never render artificial times.
  BoolColumn get isAllDay => boolean().withDefault(const Constant(false))();

  /// Google's event type (`default`, `birthday`, `focusTime`, ...). Birthdays
  /// are recognized from this, not from the calendar's name.
  TextColumn get eventType => text().withDefault(const Constant('default'))();

  /// Remind this many minutes before [startsAt]; null for no reminder.
  IntColumn get reminderMinutes => integer().nullable()();

  /// When the in-app reminder was shown, so it only fires once.
  DateTimeColumn get reminderNotifiedAt => dateTime().nullable()();

  IntColumn get categoryId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// See [EventSyncStatus]. Defaults to synced (imported Google events).
  TextColumn get syncStatus =>
      text().withDefault(const Constant(EventSyncStatus.synced))();

  /// Google etag for optimistic concurrency on PATCH.
  TextColumn get etag => text().nullable()();

  /// Last push failure message, if [syncStatus] is [EventSyncStatus.failed].
  TextColumn get syncError => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {calendarId, googleEventId},
  ];
}
