import 'package:event_reminder/data/google/google_models.dart';
import 'package:event_reminder/data/google/stub_google_auth_service.dart';
import 'package:event_reminder/data/google/stub_google_calendar_api.dart';
import 'package:event_reminder/data/local/app_database.dart';
import 'package:event_reminder/data/repositories/account_repository.dart';
import 'package:event_reminder/data/repositories/calendar_repository.dart';
import 'package:event_reminder/data/repositories/category_repository.dart';
import 'package:event_reminder/data/repositories/event_repository.dart';
import 'package:event_reminder/services/calendar_sync_service.dart';
import 'package:event_reminder/data/google/google_calendar_api.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

void main() {
  late AppDatabase db;
  late AccountRepository accounts;
  late CalendarRepository calendars;
  late EventRepository events;

  const account = StubGoogleAuthService.account;
  const personal = GoogleCalendarInfo(
    id: 'me@example.com',
    name: 'Personal',
    color: 0xFF039BE5,
    accessRole: 'owner',
    isPrimary: true,
  );
  const birthdays = GoogleCalendarInfo(
    id: 'addressbook#contacts@group.v.calendar.google.com',
    name: 'Birthdays',
    color: 0xFFE67C73,
    accessRole: 'reader',
  );
  final at = DateTime.utc(2026, 9, 29, 9);

  setUp(() async {
    db = inMemoryDatabase();
    accounts = AccountRepository(db);
    calendars = CalendarRepository(db);
    events = EventRepository(db);
    await accounts.connect(account);
    await accounts.setCalendarAccess(account.id, granted: true);
  });

  tearDown(() => db.close());

  CalendarSyncService service(GoogleCalendarApi api) => CalendarSyncService(
    api: api,
    accounts: accounts,
    calendars: calendars,
    events: events,
    categories: CategoryRepository(db),
    clock: () => at,
  );

  test('stub API: fails at import, records failure, never succeeds', () async {
    const api = StubGoogleCalendarApi(latency: Duration.zero);
    await calendars.saveSelection(account.id, StubGoogleCalendarApi.calendars, {
      StubGoogleCalendarApi.calendars.first.id,
    });

    final updates = await service(api).run(account.id).toList();

    expect(updates.whereType<SyncSucceeded>(), isEmpty);
    final failure = updates.last as SyncFailed;
    expect(failure.stage, SyncStage.importEvents);
    expect(failure.isStubLimitation, isTrue);
    expect(failure.partial.calendars, 1);
    expect(failure.partial.events, 0);

    final stored = await accounts.find(account.id);
    expect(stored!.lastSyncSuccessAt, isNull);
    expect(stored.lastSyncError, isNotNull);
  });

  test('working API: imports events and reports real counts', () async {
    final api = FakeCalendarApi(
      calendars: const [personal, birthdays],
      events: {
        personal.id: [
          GoogleEventInfo(
            id: 'e1',
            title: 'Standup',
            start: at,
            end: at.add(const Duration(minutes: 15)),
          ),
          GoogleEventInfo(
            id: 'e2',
            title: 'Lunch',
            start: at.add(const Duration(hours: 3)),
            end: at.add(const Duration(hours: 4)),
          ),
        ],
        birthdays.id: [
          GoogleEventInfo(
            id: 'b1',
            title: "Rahul's birthday",
            start: DateTime.utc(2026, 9, 29),
            end: DateTime.utc(2026, 9, 30),
            isAllDay: true,
            eventType: 'birthday',
          ),
        ],
      },
    );
    await calendars.saveSelection(account.id, api.calendars, {
      personal.id,
      birthdays.id,
    });

    final updates = await service(api).run(account.id).toList();
    final success = updates.last as SyncSucceeded;
    expect(success.report.calendars, 2);
    expect(success.report.events, 3);
    expect(success.report.birthdays, 1);

    // Birthday was categorized; running again doesn't duplicate.
    await service(api).run(account.id).toList();
    expect(await events.countForAccount(account.id), 3);
    final bday = await (db.select(
      db.events,
    )..where((e) => e.eventType.equals('birthday'))).getSingle();
    final category = await CategoryRepository(db).findBySlug('birthdays');
    expect(bday.categoryId, category!.id);

    final stored = await accounts.find(account.id);
    expect(stored!.lastSyncSuccessAt, at);
    expect(stored.lastSyncError, isNull);
  });

  test('fails early without calendar access', () async {
    await accounts.setCalendarAccess(account.id, granted: false);
    final updates = await service(
      const StubGoogleCalendarApi(latency: Duration.zero),
    ).run(account.id).toList();
    expect((updates.last as SyncFailed).stage, SyncStage.connect);
  });
}
