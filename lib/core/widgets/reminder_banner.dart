import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_colors.dart';
import '../../data/local/app_database.dart';
import '../../services/reminder_service.dart';
import 'soft_card.dart';

/// Shows due reminders as an in-app banner above every screen.
class ReminderBannerHost extends ConsumerWidget {
  const ReminderBannerHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(reminderSchedulerProvider, (previous, next) {
      if (next.length > (previous?.length ?? 0)) {
        HapticFeedback.mediumImpact();
        SystemSound.play(SystemSoundType.alert);
      }
    });
    final queue = ref.watch(reminderSchedulerProvider);
    final current = queue.isEmpty ? null : queue.first;

    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position:
                          Tween(
                            begin: const Offset(0, -1.2),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: current == null
                        ? const SizedBox.shrink()
                        : _ReminderBanner(
                            key: ValueKey(current.id),
                            event: current,
                            more: queue.length - 1,
                            onDismiss: () => ref
                                .read(reminderSchedulerProvider.notifier)
                                .dismiss(current.id),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReminderBanner extends StatelessWidget {
  const _ReminderBanner({
    super.key,
    required this.event,
    required this.more,
    required this.onDismiss,
  });

  final CalendarEvent event;
  final int more;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      label: 'Reminder',
      child: Dismissible(
        key: ValueKey('reminder-${event.id}'),
        direction: DismissDirection.up,
        onDismissed: (_) => onDismiss(),
        child: SoftCard(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        describeReminder(event, DateTime.now()),
                        if (more > 0) '+$more more',
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Dismiss',
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Starts in 10 min · 3:00 PM", "Starting now", "Today · all day".
String describeReminder(CalendarEvent event, DateTime now) {
  if (event.isAllDay) {
    final day = DateUtils.isSameDay(event.startsAt, now)
        ? 'Today'
        : DateFormat.MMMEd().format(event.startsAt);
    return '$day · all day';
  }
  final time = DateFormat.jm().format(event.startsAt);
  final minutes = event.startsAt.difference(now).inMinutes;
  if (minutes <= 0) return 'Starting now · $time';
  if (minutes < 60) return 'Starts in $minutes min · $time';
  final hours = (minutes / 60).round();
  if (hours < 24) return 'Starts in $hours h · $time';
  return '${DateFormat.MMMEd().format(event.startsAt)} · $time';
}
