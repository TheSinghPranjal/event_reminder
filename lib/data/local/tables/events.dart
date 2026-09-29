import 'package:drift/drift.dart';

import 'calendars.dart';
import 'categories.dart';

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

  IntColumn get categoryId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
  )();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {calendarId, googleEventId},
  ];
}
