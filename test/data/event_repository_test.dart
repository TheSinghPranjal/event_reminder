import 'package:event_reminder/data/google/google_models.dart';
import 'package:event_reminder/data/google/stub_google_auth_service.dart';
import 'package:event_reminder/data/local/app_database.dart';
import 'package:event_reminder/data/local/tables/events.dart';
import 'package:event_reminder/data/repositories/account_repository.dart';
import 'package:event_reminder/data/repositories/calendar_repository.dart';
import 'package:event_reminder/data/repositories/event_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_app.dart';

void main() {
  late AppDatabase db;
  late EventRepository events;
  late CalendarRepository calendars;
  late AccountRepository accounts;

  const account = StubGoogleAuthService.account;
  const personal = GoogleCalendarInfo(
    id: 'me@example.com',
    name: 'Personal',
    color: 0xFF039BE5,
    accessRole: 'owner',
    isPrimary: true,
  );

  setUp(() async {
    db = inMemoryDatabase();
    events = EventRepository(db);
    calendars = CalendarRepository(db);
    accounts = AccountRepository(db);
    await accounts.connect(account);
    await calendars.saveSelection(account.id, [personal], {personal.id});
  });

  tearDown(() => db.close());

  Future<int> calendarRowId() async =>
      (await calendars.selected(account.id)).single.id;

  test('create local vs pendingCreate based on calendarId', () async {
    final localId = await events.create(
      EventDraft(
        title: 'Local',
        startsAt: DateTime(2026, 10, 1, 10),
        endsAt: DateTime(2026, 10, 1, 11),
      ),
    );
    final local = await events.find(localId);
    expect(local!.syncStatus, EventSyncStatus.local);

    final calId = await calendarRowId();
    final syncedId = await events.create(
      EventDraft(
        title: 'Synced',
        startsAt: DateTime(2026, 10, 1, 12),
        endsAt: DateTime(2026, 10, 1, 13),
        calendarId: calId,
      ),
    );
    expect(
      (await events.find(syncedId))!.syncStatus,
      EventSyncStatus.pendingCreate,
    );
  });

  test('update keeps pendingCreate until pushed; then pendingUpdate', () async {
    final calId = await calendarRowId();
    final id = await events.create(
      EventDraft(
        title: 'Draft',
        startsAt: DateTime(2026, 10, 1, 10),
        endsAt: DateTime(2026, 10, 1, 11),
        calendarId: calId,
      ),
    );
    await events.update(
      id,
      EventDraft(
        title: 'Draft 2',
        startsAt: DateTime(2026, 10, 1, 10),
        endsAt: DateTime(2026, 10, 1, 11),
        calendarId: calId,
      ),
    );
    expect(
      (await events.find(id))!.syncStatus,
      EventSyncStatus.pendingCreate,
    );

    await events.markSynced(id, googleEventId: 'g1', etag: 'e1');
    await events.update(
      id,
      EventDraft(
        title: 'Draft 3',
        startsAt: DateTime(2026, 10, 1, 10),
        endsAt: DateTime(2026, 10, 1, 11),
        calendarId: calId,
      ),
    );
    expect(
      (await events.find(id))!.syncStatus,
      EventSyncStatus.pendingUpdate,
    );
  });

  test('delete hard-deletes local/pendingCreate; soft-deletes synced', () async {
    final calId = await calendarRowId();
    final localId = await events.create(
      EventDraft(
        title: 'Local',
        startsAt: DateTime(2026, 10, 1, 10),
        endsAt: DateTime(2026, 10, 1, 11),
      ),
    );
    await events.delete(localId);
    expect(await events.find(localId), isNull);

    final pendingId = await events.create(
      EventDraft(
        title: 'Pending',
        startsAt: DateTime(2026, 10, 1, 10),
        endsAt: DateTime(2026, 10, 1, 11),
        calendarId: calId,
      ),
    );
    await events.delete(pendingId);
    expect(await events.find(pendingId), isNull);

    final syncedId = await events.create(
      EventDraft(
        title: 'Synced',
        startsAt: DateTime(2026, 10, 1, 10),
        endsAt: DateTime(2026, 10, 1, 11),
        calendarId: calId,
      ),
    );
    await events.markSynced(syncedId, googleEventId: 'g2', etag: 'e2');
    await events.delete(syncedId);
    expect(
      (await events.find(syncedId))!.syncStatus,
      EventSyncStatus.pendingDelete,
    );
  });

  test('applyRemoteDelta skips pending rows and deletes cancelled ids', () async {
    final calId = await calendarRowId();
    await events.applyRemoteDelta(
      calId,
      GoogleEventPage(
        events: [
          GoogleEventInfo(
            id: 'keep',
            title: 'Keep me',
            start: DateTime(2026, 10, 2, 9),
            end: DateTime(2026, 10, 2, 10),
          ),
          GoogleEventInfo(
            id: 'edit-me',
            title: 'Remote title',
            start: DateTime(2026, 10, 2, 11),
            end: DateTime(2026, 10, 2, 12),
          ),
        ],
      ),
    );

    final pendingRow = await (db.select(
      db.events,
    )..where((e) => e.googleEventId.equals('edit-me'))).getSingle();
    await events.update(
      pendingRow.id,
      EventDraft(
        title: 'Local edit wins',
        startsAt: pendingRow.startsAt,
        endsAt: pendingRow.endsAt,
        calendarId: calId,
      ),
    );

    await events.applyRemoteDelta(
      calId,
      GoogleEventPage(
        events: [
          GoogleEventInfo(
            id: 'edit-me',
            title: 'Should be ignored',
            start: DateTime(2026, 10, 2, 11),
            end: DateTime(2026, 10, 2, 12),
          ),
          GoogleEventInfo(
            id: 'keep',
            title: 'Keep me updated',
            start: DateTime(2026, 10, 2, 9),
            end: DateTime(2026, 10, 2, 10),
          ),
        ],
        cancelledIds: const ['gone'],
      ),
    );

    // Seed a 'gone' event then cancel it.
    await events.applyRemoteDelta(
      calId,
      GoogleEventPage(
        events: [
          GoogleEventInfo(
            id: 'gone',
            title: 'Gone',
            start: DateTime(2026, 10, 3, 9),
            end: DateTime(2026, 10, 3, 10),
          ),
        ],
      ),
    );
    await events.applyRemoteDelta(
      calId,
      const GoogleEventPage(cancelledIds: ['gone']),
    );

    final editMe = await (db.select(
      db.events,
    )..where((e) => e.googleEventId.equals('edit-me'))).getSingle();
    expect(editMe.title, 'Local edit wins');
    expect(editMe.syncStatus, EventSyncStatus.pendingUpdate);

    final keep = await (db.select(
      db.events,
    )..where((e) => e.googleEventId.equals('keep'))).getSingle();
    expect(keep.title, 'Keep me updated');

    expect(
      await (db.select(
        db.events,
      )..where((e) => e.googleEventId.equals('gone'))).get(),
      isEmpty,
    );
  });

  test('pendingDelete is hidden from watchBetween', () async {
    final calId = await calendarRowId();
    final id = await events.create(
      EventDraft(
        title: 'Vanish',
        startsAt: DateTime(2026, 10, 5, 10),
        endsAt: DateTime(2026, 10, 5, 11),
        calendarId: calId,
      ),
    );
    await events.markSynced(id, googleEventId: 'v1', etag: 'e');
    await events.delete(id);

    final views = await events
        .watchBetween(DateTime(2026, 10, 5), DateTime(2026, 10, 6))
        .first;
    expect(views, isEmpty);
  });
}
