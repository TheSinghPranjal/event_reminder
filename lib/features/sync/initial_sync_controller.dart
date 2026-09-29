import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../services/calendar_sync_service.dart';

enum StageStatus { pending, active, done, failed }

class StageState {
  const StageState(this.status, this.label);

  final StageStatus status;
  final String label;
}

enum SyncOutcome { running, succeeded, failed }

class InitialSyncState {
  const InitialSyncState({
    required this.stages,
    this.outcome = SyncOutcome.running,
    this.report = const SyncReport(),
    this.error,
    this.isStubLimitation = false,
  });

  factory InitialSyncState.initial() => InitialSyncState(
    stages: {
      for (final s in SyncStage.values)
        s: StageState(StageStatus.pending, pendingLabel(s)),
    },
  );

  final Map<SyncStage, StageState> stages;
  final SyncOutcome outcome;
  final SyncReport report;
  final String? error;
  final bool isStubLimitation;

  int get completedCount =>
      stages.values.where((s) => s.status == StageStatus.done).length;

  static String pendingLabel(SyncStage s) => switch (s) {
    SyncStage.connect => 'Connecting to Google',
    SyncStage.pushChanges => 'Uploading local changes',
    SyncStage.loadCalendars => 'Loading calendars',
    SyncStage.importEvents => 'Importing events',
    SyncStage.findBirthdays => 'Finding birthdays',
  };

  InitialSyncState copyWith({
    Map<SyncStage, StageState>? stages,
    SyncOutcome? outcome,
    SyncReport? report,
    String? error,
    bool? isStubLimitation,
  }) => InitialSyncState(
    stages: stages ?? this.stages,
    outcome: outcome ?? this.outcome,
    report: report ?? this.report,
    error: error ?? this.error,
    isStubLimitation: isStubLimitation ?? this.isStubLimitation,
  );

  InitialSyncState withStage(
    SyncStage stage,
    StageStatus status,
    String label,
  ) => copyWith(stages: {...stages, stage: StageState(status, label)});
}

/// Runs the first sync for the active account and exposes stage-by-stage
/// progress. Only a real, fully completed sync reaches [SyncOutcome.succeeded].
class InitialSyncController extends Notifier<InitialSyncState> {
  StreamSubscription<SyncUpdate>? _sub;

  @override
  InitialSyncState build() {
    ref.onDispose(() => _sub?.cancel());
    Future.microtask(start);
    return InitialSyncState.initial();
  }

  Future<void> start() async {
    await _sub?.cancel();
    state = InitialSyncState.initial();

    final account = await ref
        .read(accountRepositoryProvider)
        .watchActive()
        .first;
    if (account == null) {
      state = state
          .withStage(
            SyncStage.connect,
            StageStatus.failed,
            'No Google account connected',
          )
          .copyWith(
            outcome: SyncOutcome.failed,
            error: 'Connect a Google account to sync your calendars.',
          );
      return;
    }

    _sub = ref
        .read(calendarSyncServiceProvider)
        .run(account.id)
        .listen(_onUpdate);
  }

  void _onUpdate(SyncUpdate update) {
    state = switch (update) {
      SyncStageStarted(:final stage) => state.withStage(
        stage,
        StageStatus.active,
        InitialSyncState.pendingLabel(stage),
      ),
      SyncStageProgress(:final stage, :final detail) => state.withStage(
        stage,
        StageStatus.active,
        detail,
      ),
      SyncStageCompleted(:final stage, :final detail) => state.withStage(
        stage,
        StageStatus.done,
        detail,
      ),
      SyncSucceeded(:final report) => state.copyWith(
        outcome: SyncOutcome.succeeded,
        report: report,
      ),
      SyncFailed(
        :final stage,
        :final message,
        :final partial,
        :final isStubLimitation,
      ) =>
        state
            .withStage(stage, StageStatus.failed, state.stages[stage]!.label)
            .copyWith(
              outcome: SyncOutcome.failed,
              error: message,
              report: partial,
              isStubLimitation: isStubLimitation,
            ),
    };
  }
}

final initialSyncControllerProvider =
    NotifierProvider.autoDispose<InitialSyncController, InitialSyncState>(
      InitialSyncController.new,
    );
