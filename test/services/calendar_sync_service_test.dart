import 'package:event_reminder/data/google/google_models.dart';
import 'package:event_reminder/data/google/stub_google_auth_service.dart';
import 'package:event_reminder/data/google/stub_google_calendar_api.dart';
import 'package:event_reminder/data/local/app_database.dart';
import 'package:event_reminder/data/local/tables/events.dart';
import 'package:event_reminder/data/repositories/account_repository.dart';
import 'package:event_reminder/data/repositories/calendar_repository.dart';
import 'package:event_reminder/data/repositories/category_repository.dart';
import 'package:event_reminder/data/repositories/event_repository.dart';
import 'package:event_reminder/services/calendar_sync_service.dart';
import 'package:event_reminder/data/google/google_calendar_api.dart';
import 'package:event_reminder/services/event_push_service.dart';
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

  CalendarSyncService service(GoogleCalendarApi api) {
    final push = EventPushService(
      api: api,
      events: events,
      calendars: calendars,
    );
    return CalendarSyncService(
      api: api,
      accounts: accounts,
      calendars: calendars,
      events: events,
      categories: CategoryRepository(db),
      push: push,
      clock: () => at,
    );
  }

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

    // Sync tokens persisted.
    final selected = await calendars.selected(account.id);
    expect(selected.every((c) => c.syncToken != null), isTrue);
  });

  test('pushes pending creates before importing', () async {
    final api = FakeCalendarApi(calendars: const [personal], events: {});
    await calendars.saveSelection(account.id, api.calendars, {personal.id});
    final calId = (await calendars.selected(account.id)).single.id;
    await events.create(
      EventDraft(
        title: 'New meeting',
        startsAt: at,
        endsAt: at.add(const Duration(hours: 1)),
        calendarId: calId,
      ),
    );

    final updates = await service(api).run(account.id).toList();
    expect(updates.last, isA<SyncSucceeded>());
    expect(api.insertedIds, hasLength(1));
    final row = await (db.select(db.events)).getSingle();
    expect(row.syncStatus, EventSyncStatus.synced);
    expect(row.googleEventId, isNotNull);
  });

  test('410 sync token triggers full re-import', () async {
    final api = FakeCalendarApi(
      calendars: const [personal],
      events: {
        personal.id: [
          GoogleEventInfo(
            id: 'e1',
            title: 'Standup',
            start: at,
            end: at.add(const Duration(minutes: 15)),
          ),
        ],
      },
      expireSyncTokenOnce: true,
    );
    await calendars.saveSelection(account.id, api.calendars, {personal.id});
    final calId = (await calendars.selected(account.id)).single.id;
    await calendars.setSyncToken(calId, 'stale-token');

    final updates = await service(api).run(account.id).toList();
    expect(updates.last, isA<SyncSucceeded>());
    expect(await events.countForAccount(account.id), 1);
    final refreshed = await calendars.find(calId);
    expect(refreshed!.syncToken, isNotNull);
    expect(refreshed.syncToken, isNot('stale-token'));
  });

  test('per-event push failure is recorded without failing the run', () async {
    final api = _FailingInsertApi(
      calendars: const [personal],
      events: {
        personal.id: [
          GoogleEventInfo(
            id: 'remote',
            title: 'Remote',
            start: at,
            end: at.add(const Duration(hours: 1)),
          ),
        ],
      },
    );
    await calendars.saveSelection(account.id, api.calendars, {personal.id});
    final calId = (await calendars.selected(account.id)).single.id;
    final pendingId = await events.create(
      EventDraft(
        title: 'Will fail',
        startsAt: at,
        endsAt: at.add(const Duration(hours: 1)),
        calendarId: calId,
      ),
    );

    final updates = await service(api).run(account.id).toList();
    expect(updates.last, isA<SyncSucceeded>());
    final failed = await events.find(pendingId);
    expect(failed!.syncStatus, EventSyncStatus.failed);
    expect(failed.syncError, isNotNull);
    expect(await events.countForAccount(account.id), 2);
  });

  test('fails early without calendar access', () async {
    await accounts.setCalendarAccess(account.id, granted: false);
    final updates = await service(
      const StubGoogleCalendarApi(latency: Duration.zero),
    ).run(account.id).toList();
    expect((updates.last as SyncFailed).stage, SyncStage.connect);
  });
}

class _FailingInsertApi extends FakeCalendarApi {
  _FailingInsertApi({required super.calendars, super.events});

  @override
  Future<GoogleEventInfo> insertEvent(
    String accountId,
    String calendarId,
    GoogleEventDraft draft,
  ) async {
    throw const GoogleApiException('Insert denied');
  }
}
