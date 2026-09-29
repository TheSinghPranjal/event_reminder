import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/glow_button.dart';
import '../../../core/widgets/stub_notice.dart';
import '../../../services/calendar_sync_service.dart';
import '../initial_sync_controller.dart';
import 'sync_illustrations.dart';

/// "Setting everything up…": live sync stages with real counts.
class InitialSyncScreen extends ConsumerWidget {
  const InitialSyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final state = ref.watch(initialSyncControllerProvider);
    final failed = state.outcome == SyncOutcome.failed;

    ref.listen(initialSyncControllerProvider.select((s) => s.outcome), (
      _,
      outcome,
    ) {
      if (outcome == SyncOutcome.succeeded) context.go(Routes.setupComplete);
    });

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPagePadding + 12,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 190,
                      child: SyncIllustration(active: !failed),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      failed ? 'Sync didn\'t finish' : 'Setting everything up…',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 28),
                    for (final stage in SyncStage.values)
                      _StageRow(state: state.stages[stage]!),
                    const Spacer(),
                    const SizedBox(height: 24),
                    if (failed)
                      _FailurePanel(state: state)
                    else
                      _StepProgress(state: state),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  const _StageRow({required this.state});

  final StageState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final label = switch (state.status) {
      StageStatus.active || StageStatus.pending => '${state.label}…',
      _ => state.label,
    };
    final color = switch (state.status) {
      StageStatus.pending => scheme.onSurfaceVariant.withValues(alpha: 0.7),
      StageStatus.failed => scheme.error,
      _ => scheme.onSurface,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, a) =>
                ScaleTransition(scale: a, child: child),
            child: _StageIcon(
              key: ValueKey(state.status),
              status: state.status,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                color: color,
                fontWeight: state.status == StageStatus.active
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StageIcon extends StatelessWidget {
  const _StageIcon({super.key, required this.status});

  final StageStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const size = 32.0;
    switch (status) {
      case StageStatus.done:
        return const CircleAvatar(
          radius: size / 2,
          backgroundColor: AppColors.success,
          child: Icon(Icons.check_rounded, color: Colors.white, size: 20),
        );
      case StageStatus.failed:
        return CircleAvatar(
          radius: size / 2,
          backgroundColor: scheme.error,
          child: const Icon(
            Icons.priority_high_rounded,
            color: Colors.white,
            size: 18,
          ),
        );
      case StageStatus.active:
        return Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.primary.withValues(alpha: 0.08),
            border: Border.all(
              color: scheme.primary.withValues(alpha: 0.25),
              width: 2,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        );
      case StageStatus.pending:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: scheme.outline, width: 2),
          ),
        );
    }
  }
}

/// Progress is the share of stages completed: the only thing we can
/// measure honestly before the event count is known.
class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.state});

  final InitialSyncState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = state.stages.length;
    final done = state.completedCount;
    final current = (done + 1).clamp(1, total);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                label: 'Sync progress',
                value: 'Step $current of $total',
                child: ExcludeSemantics(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(end: done / total),
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, _) =>
                          LinearProgressIndicator(value: value, minHeight: 10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            ExcludeSemantics(
              child: Text(
                'Step $current of $total',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'This may take a few moments.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _FailurePanel extends ConsumerWidget {
  const _FailurePanel({required this.state});

  final InitialSyncState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final partial = state.report;
    final saved = [
      if (partial.calendars > 0)
        '${partial.calendars} calendar${partial.calendars == 1 ? '' : 's'}',
      if (partial.events > 0)
        '${partial.events} event${partial.events == 1 ? '' : 's'}',
    ];

    return Column(
      children: [
        if (state.isStubLimitation)
          StubNotice(message: state.error ?? 'Sync is not available.')
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.errorContainer,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Text(
              state.error ?? 'Sync failed.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onErrorContainer,
              ),
            ),
          ),
        if (saved.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            'Saved so far: ${saved.join(' and ')}.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 16),
        GlowButton(
          label: 'Try again',
          onPressed: () =>
              ref.read(initialSyncControllerProvider.notifier).start(),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => context.go(Routes.home),
          child: const Text('Continue offline'),
        ),
      ],
    );
  }
}
