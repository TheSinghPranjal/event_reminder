import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/glow_button.dart';
import '../../../data/local/app_database.dart';
import '../../../data/providers.dart';
import '../providers/account_providers.dart';
import 'sync_illustrations.dart';

class SetupSummary {
  const SetupSummary({
    required this.account,
    required this.events,
    required this.birthdays,
    required this.perCalendar,
  });

  final LinkedAccount account;
  final int events;
  final int birthdays;
  final Map<SyncedCalendar, int> perCalendar;
}

/// Counts read back from the database, so they reflect what was stored.
final setupSummaryProvider = FutureProvider.autoDispose<SetupSummary?>((
  ref,
) async {
  final account = await ref.watch(activeAccountProvider.future);
  if (account == null) return null;
  final events = ref.read(eventRepositoryProvider);
  return SetupSummary(
    account: account,
    events: await events.countForAccount(account.id),
    birthdays: await events.countForAccount(account.id, birthdaysOnly: true),
    perCalendar: await events.countsByCalendar(account.id),
  );
});

class SetupCompleteScreen extends ConsumerWidget {
  const SetupCompleteScreen({super.key});

  static String _plural(int n, String noun) => '$n $noun${n == 1 ? '' : 's'}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final summaryAsync = ref.watch(setupSummaryProvider);
    final summary = summaryAsync.value;

    // Only a sync that really completed may show this screen.
    final synced = summary?.account.lastSyncSuccessAt != null;
    if (summaryAsync.hasValue && !synced) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(Routes.home);
      });
      return const Scaffold();
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPagePadding + 4),
          child: Column(
            children: [
              const Expanded(flex: 5, child: Center(child: SuccessBurst())),
              Text('You\'re all set!', style: theme.textTheme.headlineLarge),
              const SizedBox(height: 10),
              Text(
                summary == null
                    ? ' '
                    : 'We found ${_plural(summary.events, 'event')} and '
                          '${_plural(summary.birthdays, 'birthday')}.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 17,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 28),
              if (summary != null) _StatsPill(summary: summary),
              const Spacer(flex: 3),
              GlowButton(
                label: 'Go to My Day',
                onPressed: () => context.go(Routes.home),
              ),
              const SizedBox(height: 8),
              TextButton(
                style: TextButton.styleFrom(foregroundColor: scheme.primary),
                onPressed: summary == null
                    ? null
                    : () => _showDetails(context, summary),
                child: const Text('View sync details'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, SetupSummary summary) {
    final last = summary.account.lastSyncSuccessAt;
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              kPagePadding,
              0,
              kPagePadding,
              kPagePadding,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sync details', style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  [
                    summary.account.email,
                    if (last != null)
                      'Last synced ${DateFormat.MMMd().add_jm().format(last.toLocal())}',
                  ].join(' · '),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                for (final MapEntry(key: cal, value: count)
                    in summary.perCalendar.entries)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 7,
                      backgroundColor: Color(cal.color),
                    ),
                    title: Text(cal.name),
                    trailing: Text(_plural(count, 'event')),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatsPill extends StatelessWidget {
  const _StatsPill({required this.summary});

  final SetupSummary summary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final calendars = summary.perCalendar.length;
    Widget divider() => Container(
      width: 1,
      height: 18,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: scheme.outline,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? scheme.surfaceContainer : const Color(0xFFF9FAFC),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: FittedBox(
        child: Row(
          children: [
            _Stat(color: AppColors.primary, label: '${summary.events} Events'),
            divider(),
            _Stat(
              color: const Color(0xFFEC4899),
              label: '${summary.birthdays} Birthdays',
            ),
            divider(),
            _Stat(
              color: AppColors.success,
              label: '$calendars Calendar${calendars == 1 ? '' : 's'}',
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
