import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/planly_header.dart';
import '../../core/widgets/soft_card.dart';
import '../../data/repositories/event_repository.dart';
import '../categories/category_icons.dart';
import 'event_providers.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(upcomingEventsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PlanlyHeader(title: 'My Events'),
            Expanded(
              child: switch (events) {
                AsyncData(:final value) when value.isEmpty => EmptyState(
                  icon: Icons.event_note_rounded,
                  title: 'No events yet',
                  message:
                      'Your meetings, birthdays, trips and plans will live here.',
                  action: OutlinedButton.icon(
                    onPressed: () => context.push(Routes.eventNew),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Create event'),
                  ),
                ),
                AsyncData(:final value) => _GroupedList(events: value),
                AsyncError() => Center(
                  child: Text(
                    'Couldn\'t load events.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: scheme.error,
                    ),
                  ),
                ),
                _ => const Center(child: CircularProgressIndicator()),
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(Routes.eventNew),
        tooltip: 'Create event',
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

class _GroupedList extends StatelessWidget {
  const _GroupedList({required this.events});

  final List<EventView> events;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groups = <DateTime, List<EventView>>{};
    for (final e in events) {
      final day = DateUtils.dateOnly(e.event.startsAt.toLocal());
      groups.putIfAbsent(day, () => []).add(e);
    }
    final days = groups.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(kPagePadding, 8, kPagePadding, 96),
      itemCount: days.length,
      itemBuilder: (context, i) {
        final day = days[i];
        final items = groups[day]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 16, bottom: 8),
              child: Text(
                DateFormat.yMMMEd().format(day),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            for (final view in items) ...[
              _EventTile(view: view),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.view});

  final EventView view;

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
    final time = e.isAllDay
        ? 'All day'
        : '${DateFormat.jm().format(e.startsAt.toLocal())}'
              ' – ${DateFormat.jm().format(e.endsAt.toLocal())}';
    final subtitle = [
      time,
      ?view.category?.name ?? view.calendar?.name,
      ?e.location,
    ].join(' · ');

    return SoftCard(
      onTap: () => context.push(Routes.eventDetails(e.id)),
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
          Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
