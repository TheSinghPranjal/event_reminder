import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:event_reminder/data/google/google_models.dart';
import 'package:event_reminder/data/google/stub_google_auth_service.dart';
import 'package:event_reminder/data/local/app_database.dart';
import 'package:event_reminder/data/providers.dart';
import 'package:event_reminder/data/repositories/account_repository.dart';
import 'package:event_reminder/data/repositories/calendar_repository.dart';
import 'package:event_reminder/data/repositories/event_repository.dart';
import 'package:event_reminder/services/reminder_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late EventRepository events;

  setUp(() => db = inMemoryDatabase());
  tearDown(() => db.close());

  Future<int> seedCalendar() async {
    await AccountRepository(db).connect(StubGoogleAuthService.account);
    const id = 'me@example.com';
    final calendars = CalendarRepository(db);
    await calendars.saveSelection(
      StubGoogleAuthService.account.id,
      const [
        GoogleCalendarInfo(
          id: id,
          name: 'Personal',
          color: 0xFF039BE5,
          accessRole: 'owner',
        ),
      ],
      {id},
    );
    events = EventRepository(db);
    return (await calendars.selected(
      StubGoogleAuthService.account.id,
    )).single.id;
  }

  GoogleEventInfo event(DateTime start, {int? reminder = 10}) =>
      GoogleEventInfo(
        id: 'standup',
        title: 'Standup',
        start: start,
        end: start.add(const Duration(minutes: 30)),
        reminderMinutes: reminder,
      );

  group('EventRepository reminders', () {
    test('synced events keep their reminder in the local database', () async {
      final calendarId = await seedCalendar();
      await events.upsertGoogleEvents(calendarId, [
        event(DateTime(2026, 10, 1, 9)),
      ]);

      final row = await db.select(db.events).getSingle();
      expect(row.title, 'Standup');
      expect(row.reminderMinutes, 10);
      expect(row.reminderNotifiedAt, isNull);
    });

    test('re-sync keeps a shown reminder dismissed unless it moved', () async {
      final calendarId = await seedCalendar();
      final start = DateTime(2026, 10, 1, 9);
      await events.upsertGoogleEvents(calendarId, [event(start)]);
      final row = await db.select(db.events).getSingle();
      await events.markReminderNotified(row.id, DateTime(2026, 10, 1, 8, 50));

      await events.upsertGoogleEvents(calendarId, [event(start)]);
      expect(
        (await db.select(db.events).getSingle()).reminderNotifiedAt,
        isNotNull,
      );

      await events.upsertGoogleEvents(calendarId, [
        event(start.add(const Duration(hours: 1))),
      ]);
      expect(
        (await db.select(db.events).getSingle()).reminderNotifiedAt,
        isNull,
      );
    });
  });

  group('ReminderScheduler', () {
    ProviderContainer container(DateTime Function() clock) {
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          reminderClockProvider.overrideWithValue(clock),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    Future<void> pump() =>
        Future<void>.delayed(const Duration(milliseconds: 50));

    test('raises a due reminder once and records it', () async {
      final calendarId = await seedCalendar();
      final now = DateTime(2026, 10, 1, 8, 52);
      await events.upsertGoogleEvents(calendarId, [
        event(DateTime(2026, 10, 1, 9)),
      ]);

      final c = container(() => now);
      c.listen(reminderSchedulerProvider, (_, _) {});
      await pump();

      final queue = c.read(reminderSchedulerProvider);
      expect(queue.map((e) => e.title), ['Standup']);
      expect((await db.select(db.events).getSingle()).reminderNotifiedAt, now);

      c.read(reminderSchedulerProvider.notifier).dismiss(queue.single.id);
      await pump();
      expect(c.read(reminderSchedulerProvider), isEmpty);
    });

    test('fires when the reminder time arrives', () async {
      final calendarId = await seedCalendar();
      final start = DateTime.now().add(const Duration(minutes: 10, seconds: 1));
      await events.upsertGoogleEvents(calendarId, [event(start)]);

      final c = container(DateTime.now);
      c.listen(reminderSchedulerProvider, (_, _) {});
      await pump();
      expect(c.read(reminderSchedulerProvider), isEmpty);

      await Future<void>.delayed(const Duration(milliseconds: 1200));
      expect(c.read(reminderSchedulerProvider).map((e) => e.title), [
        'Standup',
      ]);
    });

    test('ignores events without a reminder or long past', () async {
      final calendarId = await seedCalendar();
      await events.upsertGoogleEvents(calendarId, [
        event(DateTime(2026, 10, 1, 9), reminder: null),
      ]);
      await db
          .into(db.events)
          .insert(
            EventsCompanion.insert(
              title: 'Old',
              startsAt: DateTime(2026, 9, 30, 9),
              endsAt: DateTime(2026, 9, 30, 10),
              reminderMinutes: const Value(10),
            ),
          );

      final c = container(() => DateTime(2026, 10, 1, 8, 55));
      c.listen(reminderSchedulerProvider, (_, _) {});
      await pump();
      expect(c.read(reminderSchedulerProvider), isEmpty);
    });
  });
}
