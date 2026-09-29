import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/soft_card.dart';
import '../../data/local/tables/events.dart';
import '../../data/providers.dart';
import '../../data/repositories/event_repository.dart';
import '../../services/event_push_service.dart';
import '../categories/category_icons.dart';
import '../sync/providers/account_providers.dart';
import 'event_providers.dart';

class EventDetailsScreen extends ConsumerWidget {
  const EventDetailsScreen({super.key, required this.eventId});

  final int eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(eventViewProvider(eventId));
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
        actions: [
          async.maybeWhen(
            data: (view) {
              if (view == null) return const SizedBox.shrink();
              final writable = view.calendar == null ||
                  view.calendar!.accessRole == 'owner' ||
                  view.calendar!.accessRole == 'writer';
              if (!writable) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'Edit',
                onPressed: () => context.push(Routes.eventEdit(eventId)),
                icon: const Icon(Icons.edit_rounded),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Couldn\'t load this event.')),
        data: (view) {
          if (view == null) {
            return const Center(child: Text('This event no longer exists.'));
          }
          return _Body(view: view, eventId: eventId);
        },
      ),
      bottomNavigationBar: async.maybeWhen(
        data: (view) {
          if (view == null) return null;
          final writable = view.calendar == null ||
              view.calendar!.accessRole == 'owner' ||
              view.calendar!.accessRole == 'writer';
          if (!writable) return null;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                kPagePadding,
                8,
                kPagePadding,
                12,
              ),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.error,
                  side: BorderSide(color: scheme.error),
                ),
                onPressed: () => _confirmDelete(context, ref, view),
                icon: const Icon(Icons.delete_outline_rounded),
                label: const Text('Delete event'),
              ),
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    EventView view,
  ) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Delete event?', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                view.event.calendarId == null
                    ? 'This removes the event from Planly.'
                    : 'This deletes the event from Google Calendar too once synced.',
                style: Theme.of(ctx).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(ctx).colorScheme.error,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await ref.read(eventRepositoryProvider).delete(eventId);
    final account = ref.read(activeAccountProvider).value;
    if (account != null &&
        account.calendarAccessGranted &&
        view.event.calendarId != null) {
      unawaited(ref.read(eventPushServiceProvider).pushPending(account.id));
    }
    if (context.mounted) context.go(Routes.events);
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.view, required this.eventId});

  final EventView view;
  final int eventId;

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
    final when = e.isAllDay
        ? e.startsAt.day == e.endsAt.subtract(const Duration(days: 1)).day &&
                  e.startsAt.month ==
                      e.endsAt.subtract(const Duration(days: 1)).month
              ? 'All day · ${DateFormat.yMMMEd().format(e.startsAt.toLocal())}'
              : 'All day · ${DateFormat.MMMd().format(e.startsAt.toLocal())}'
                    ' – ${DateFormat.MMMd().format(e.endsAt.toLocal())}'
        : '${DateFormat.yMMMEd().add_jm().format(e.startsAt.toLocal())}'
              ' – ${DateFormat.jm().format(e.endsAt.toLocal())}';

    return ListView(
      padding: const EdgeInsets.fromLTRB(kPagePadding, 8, kPagePadding, 32),
      children: [
        SoftCard(
          color: color.withValues(alpha: 0.12),
          child: Row(
            children: [
              IconBadge(icon: icon, color: color, size: 56),
              const SizedBox(width: 16),
              Expanded(
                child: Text(e.title, style: theme.textTheme.headlineSmall),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SoftCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(icon: Icons.schedule_rounded, text: when),
              if (view.calendar != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.calendar_month_rounded,
                  text: view.calendar!.name,
                ),
              ],
              if (view.category != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: categoryIcon(view.category!.iconKey),
                  text: view.category!.name,
                ),
              ],
              if (e.location != null && e.location!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.place_outlined, text: e.location!),
              ],
              if (e.description != null && e.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _InfoRow(icon: Icons.notes_rounded, text: e.description!),
              ],
              if (e.reminderMinutes != null) ...[
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.notifications_active_outlined,
                  text: e.reminderMinutes == 0
                      ? 'Reminds at time of event'
                      : 'Reminds ${e.reminderMinutes} min before',
                ),
              ],
              const SizedBox(height: 16),
              _SyncChip(status: e.syncStatus, error: e.syncError),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () => context.push(Routes.eventEdit(eventId)),
          icon: const Icon(Icons.edit_rounded),
          label: const Text('Edit'),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
      ],
    );
  }
}

class _SyncChip extends StatelessWidget {
  const _SyncChip({required this.status, this.error});

  final String status;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      EventSyncStatus.local => ('Local only', scheme.onSurfaceVariant),
      EventSyncStatus.synced => ('Synced', scheme.tertiary),
      EventSyncStatus.pendingCreate ||
      EventSyncStatus.pendingUpdate ||
      EventSyncStatus.pendingDelete => ('Pending sync', scheme.primary),
      EventSyncStatus.failed => ('Sync failed', scheme.error),
      _ => (status, scheme.onSurfaceVariant),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (status == EventSyncStatus.failed && error != null) ...[
          const SizedBox(height: 8),
          Text(
            error!,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: scheme.error),
          ),
        ],
      ],
    );
  }
}
