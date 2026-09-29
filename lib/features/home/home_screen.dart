import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/planly_header.dart';
import '../../core/widgets/soft_card.dart';
import '../../data/local/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/event_repository.dart';
import '../categories/category_icons.dart';
import '../sync/providers/account_providers.dart';

/// Events for the calendar day starting at [day] (local midnight).
final dayEventsProvider = StreamProvider.autoDispose
    .family<List<EventView>, DateTime>(
      (ref, day) => ref
          .watch(eventRepositoryProvider)
          .watchBetween(day, DateTime(day.year, day.month, day.day + 1)),
    );

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static String greetingFor(DateTime now) {
    final hour = now.hour;
    if (hour < 5) return 'Good evening';
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final account = ref.watch(activeAccountProvider).value;
    final events = ref.watch(dayEventsProvider(today));

    // Only greet by name with a real Google profile name.
    final firstName = account == null || account.isStub
        ? null
        : account.displayName?.split(' ').first;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PlanlyHeader(title: 'Home'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  kPagePadding,
                  8,
                  kPagePadding,
                  32,
                ),
                children: [
                  Text(
                    '${greetingFor(now)}${firstName == null ? '' : ', $firstName'} 👋',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEE, MMM d, y').format(now),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  switch (events) {
                    AsyncData(:final value) => _SummaryCard(
                      events: value,
                      now: now,
                    ),
                    AsyncError() => const SoftCard(
                      child: Text('Couldn\'t load today\'s events.'),
                    ),
                    _ => const SizedBox(height: 120),
                  },
                  const SizedBox(height: 16),
                  _SyncBar(account: account, now: now),
                  const SizedBox(height: 28),
                  _TodaySection(events: events.value ?? const [], now: now),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.events, required this.now});

  final List<EventView> events;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final timed = events.where((e) => !e.event.isAllDay).toList();
    final finished = timed.where((e) => e.event.endsAt.isBefore(now)).length;
    final birthdays = events.where((e) => e.isBirthday).length;
    final others = events.length - birthdays;

    final parts = [
      '$others event${others == 1 ? '' : 's'}',
      if (birthdays > 0) '$birthdays birthday${birthdays == 1 ? '' : 's'}',
    ];
    final title = events.isEmpty
        ? 'Your day is clear'
        : timed.isNotEmpty && finished == timed.length
        ? 'All done for today'
        : finished > 0
        ? 'You\'re on track'
        : 'Here\'s your day';

    return SoftCard(
      radius: AppRadius.xl,
      padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 6),
                Text(
                  events.isEmpty
                      ? 'Nothing scheduled today.'
                      : parts.join(' • '),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                if (timed.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      CircleAvatar(radius: 5, backgroundColor: scheme.tertiary),
                      const SizedBox(width: 8),
                      Text(
                        '$finished OF ${timed.length} DONE',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: scheme.tertiary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (timed.isEmpty)
            IconBadge(
              icon: Icons.wb_sunny_rounded,
              color: AppColors.warning,
              size: 64,
            )
          else
            _ProgressRing(value: finished / timed.length),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => SizedBox.square(
        dimension: 76,
        child: CustomPaint(
          painter: _RingPainter(
            v,
            track: scheme.primaryContainer,
            color: scheme.primary,
          ),
          child: Center(
            child: Text(
              '${(v * 100).round()}%',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter(this.value, {required this.track, required this.color});

  final double value;
  final Color track;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 8.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = track);
    if (value > 0) {
      canvas.drawArc(
        rect,
        -math.pi / 2,
        math.pi * 2 * value,
        false,
        paint..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.color != color || old.track != track;
}

/// Real connection/sync status. Never claims a sync that didn't happen.
class _SyncBar extends StatelessWidget {
  const _SyncBar({required this.account, required this.now});

  final LinkedAccount? account;
  final DateTime now;

  static String _ago(DateTime t, DateTime now) {
    final d = now.difference(t);
    if (d.inMinutes < 1) return 'just now';
    if (d.inMinutes < 60) {
      return '${d.inMinutes} minute${d.inMinutes == 1 ? '' : 's'} ago';
    }
    if (d.inHours < 24) {
      return '${d.inHours} hour${d.inHours == 1 ? '' : 's'} ago';
    }
    return 'on ${DateFormat.MMMd().format(t)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final a = account;
    final lastOk = a?.lastSyncSuccessAt?.toLocal();
    final lastAttempt = a?.lastSyncAttemptAt?.toLocal();
    final failedLast =
        a?.lastSyncError != null &&
        lastAttempt != null &&
        (lastOk == null || lastAttempt.isAfter(lastOk));

    final (IconData icon, String text, String route, bool warn) = switch (a) {
      null => (
        Icons.link_rounded,
        'Connect Google Calendar',
        Routes.connect,
        false,
      ),
      _ when failedLast => (
        Icons.sync_problem_rounded,
        lastOk == null
            ? 'Sync didn\'t finish · tap to retry'
            : 'Last sync failed · synced ${_ago(lastOk, now)}',
        Routes.initialSync,
        true,
      ),
      _ when lastOk != null => (
        Icons.sync_rounded,
        'Synced ${_ago(lastOk, now)}',
        Routes.initialSync,
        false,
      ),
      _ => (Icons.sync_rounded, 'Not synced yet', Routes.initialSync, false),
    };

    final bg = warn ? scheme.errorContainer : scheme.primaryContainer;
    final fg = warn ? scheme.onErrorContainer : scheme.onSurface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Icon(icon, color: warn ? fg : scheme.primary, size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _TodaySection extends StatelessWidget {
  const _TodaySection({required this.events, required this.now});

  final List<EventView> events;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final left = events
        .where((e) => e.event.isAllDay || e.event.endsAt.isAfter(now))
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'Today',
                style: theme.textTheme.headlineMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            if (events.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$left Left',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: scheme.primary),
              onPressed: () => context.go(Routes.calendar),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('See all'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (events.isEmpty)
          SoftCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                IconBadge(
                  icon: Icons.event_available_rounded,
                  color: scheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nothing scheduled today',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Events from your calendars will appear here.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          for (final (i, e) in events.indexed)
            _TimelineRow(view: e, now: now, isLast: i == events.length - 1),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.view,
    required this.now,
    required this.isLast,
  });

  final EventView view;
  final DateTime now;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final e = view.event;
    final color = view.category != null
        ? Color(view.category!.color)
        : view.calendar != null
        ? Color(view.calendar!.color)
        : scheme.primary;
    final icon = view.category != null
        ? categoryIcon(view.category!.iconKey)
        : view.isBirthday
        ? Icons.cake_rounded
        : Icons.event_rounded;
    final time = DateFormat.jm();
    final timeLabel = e.isAllDay
        ? 'All day'
        : time.format(e.startsAt.toLocal());
    final subtitle = [
      ?view.category?.name ?? view.calendar?.name,
      if (!e.isAllDay)
        '${time.format(e.startsAt.toLocal())} - ${time.format(e.endsAt.toLocal())}',
      ?e.location,
    ].join(' • ');
    final past = !e.isAllDay && e.endsAt.isBefore(now);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Text(
                timeLabel,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.visible,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 28,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (!isLast)
                  Positioned(
                    top: 30,
                    bottom: 0,
                    child: Container(width: 2, color: scheme.primaryContainer),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: CircleAvatar(radius: 6, backgroundColor: color),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Opacity(
                opacity: past ? 0.6 : 1,
                child: SoftCard(
                  child: Row(
                    children: [
                      IconBadge(icon: icon, color: color, size: 44),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.title,
                              style: theme.textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (subtitle.isNotEmpty)
                              Text(
                                subtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
