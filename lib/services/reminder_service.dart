import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../data/providers.dart';

/// How long after an event starts its reminder is still worth showing
/// (e.g. the app was closed when it was due).
const reminderGrace = Duration(minutes: 5);

extension ReminderTime on CalendarEvent {
  DateTime? get remindAt => reminderMinutes == null
      ? null
      : startsAt.subtract(Duration(minutes: reminderMinutes!));
}

/// Watches local events and, while the app is open, raises each due
/// reminder once. State is the queue of reminders waiting to be dismissed.
class ReminderScheduler extends Notifier<List<CalendarEvent>> {
  StreamSubscription<List<CalendarEvent>>? _subscription;
  Timer? _timer;
  List<CalendarEvent> _pending = const [];

  DateTime Function() get _clock => ref.read(reminderClockProvider);

  @override
  List<CalendarEvent> build() {
    final lifecycle = AppLifecycleListener(onResume: _subscribe);
    ref.onDispose(() {
      lifecycle.dispose();
      _timer?.cancel();
      _subscription?.cancel();
    });
    _subscribe();
    return const [];
  }

  /// (Re)reads pending reminders. Timers don't run while the app is
  /// suspended, so this also runs on resume.
  void _subscribe() {
    _subscription?.cancel();
    _subscription = ref
        .read(eventRepositoryProvider)
        .watchPendingReminders(_clock().subtract(reminderGrace))
        .listen((events) {
          _pending = events;
          _schedule();
        });
  }

  void _schedule() {
    _timer?.cancel();
    final now = _clock();
    DateTime? next;
    final due = <CalendarEvent>[];
    for (final e in _pending) {
      final at = e.remindAt!;
      if (now.isAfter(e.startsAt.add(reminderGrace))) continue;
      if (!at.isAfter(now)) {
        due.add(e);
      } else if (next == null || at.isBefore(next)) {
        next = at;
      }
    }
    if (due.isNotEmpty) {
      _fire(due, now);
    } else if (next != null) {
      _timer = Timer(next.difference(now), _schedule);
    }
  }

  Future<void> _fire(List<CalendarEvent> due, DateTime now) async {
    final queued = {for (final e in state) e.id};
    state = [
      ...state,
      for (final e in due)
        if (!queued.contains(e.id)) e,
    ];
    final events = ref.read(eventRepositoryProvider);
    // Marking them notified re-emits the stream, which schedules the next.
    for (final e in due) {
      await events.markReminderNotified(e.id, now);
    }
  }

  void dismiss(int eventId) {
    state = [
      for (final e in state)
        if (e.id != eventId) e,
    ];
  }
}

/// Overridable in tests.
final reminderClockProvider = Provider<DateTime Function()>(
  (ref) => DateTime.now,
);

final reminderSchedulerProvider =
    NotifierProvider<ReminderScheduler, List<CalendarEvent>>(
      ReminderScheduler.new,
    );
