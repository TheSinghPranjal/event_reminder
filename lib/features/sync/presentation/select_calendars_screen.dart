import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/glow_button.dart';
import '../../../core/widgets/soft_card.dart';
import '../../../core/widgets/stub_notice.dart';
import '../../../data/google/google_models.dart';
import '../../../data/providers.dart';
import '../providers/account_providers.dart';

/// Calendars on the active account, fresh from the Google Calendar API.
final availableCalendarsProvider =
    FutureProvider.autoDispose<List<GoogleCalendarInfo>>((ref) async {
      final account = await ref.watch(activeAccountProvider.future);
      if (account == null) {
        throw const GoogleApiException('Connect a Google account first.');
      }
      final calendars = await ref
          .watch(googleCalendarApiProvider)
          .listCalendars(account.id);
      // Primary first, then Google's order.
      return [
        ...calendars.where((c) => c.isPrimary),
        ...calendars.where((c) => !c.isPrimary),
      ];
    });

class SelectCalendarsScreen extends ConsumerStatefulWidget {
  const SelectCalendarsScreen({super.key});

  @override
  ConsumerState<SelectCalendarsScreen> createState() =>
      _SelectCalendarsScreenState();
}

class _SelectCalendarsScreenState extends ConsumerState<SelectCalendarsScreen> {
  Set<String>? _selected;
  String _query = '';
  bool _saving = false;

  static const _searchThreshold = 6;

  Set<String> _defaults(List<GoogleCalendarInfo> calendars) => {
    for (final c in calendars)
      if (c.isPrimary || c.selectedInGoogle) c.id,
  };

  Future<void> _continue(List<GoogleCalendarInfo> calendars) async {
    final account = ref.read(activeAccountProvider).value;
    if (account == null) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(calendarRepositoryProvider)
          .saveSelection(account.id, calendars, _selected!);
      if (mounted) context.go(Routes.initialSync);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Couldn\'t save your selection.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calendars = ref.watch(availableCalendarsProvider);
    final isStub = ref.watch(googleCalendarApiProvider).isStub;

    return Scaffold(
      body: SafeArea(
        child: switch (calendars) {
          AsyncData(:final value) => _buildList(context, value, isStub),
          AsyncError(:final error) => _ErrorState(
            message: error is GoogleApiException
                ? error.message
                : 'Couldn\'t load your calendars.',
            onRetry: () => ref.invalidate(availableCalendarsProvider),
            onSkip: () => context.go(Routes.home),
          ),
          _ => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const Expanded(child: Center(child: CircularProgressIndicator())),
              Padding(
                padding: const EdgeInsets.all(kPagePadding),
                child: Text(
                  'Fetching your calendars…',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        },
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<GoogleCalendarInfo> calendars,
    bool isStub,
  ) {
    final selected = _selected ??= _defaults(calendars);
    final allSelected = selected.length == calendars.length;
    final q = _query.trim().toLowerCase();
    final visible = q.isEmpty
        ? calendars
        : calendars.where((c) => c.name.toLowerCase().contains(q)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Header(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              kPagePadding,
              4,
              kPagePadding,
              16,
            ),
            children: [
              if (isStub) ...[
                const StubNotice(
                  message:
                      'These calendars are placeholders, not your Google '
                      'calendars.',
                ),
                const SizedBox(height: 14),
              ],
              if (calendars.isNotEmpty)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${selected.length} of ${calendars.length} selected',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () => setState(() {
                        _selected = allSelected
                            ? <String>{}
                            : calendars.map((c) => c.id).toSet();
                      }),
                      child: Text(allSelected ? 'Clear all' : 'Select all'),
                    ),
                  ],
                ),
              if (calendars.length > _searchThreshold) ...[
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    hintText: 'Search calendars',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              if (calendars.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 48),
                  child: Center(
                    child: Text('No calendars found on this account.'),
                  ),
                ),
              for (final c in visible) ...[
                _CalendarTile(
                  calendar: c,
                  selected: selected.contains(c.id),
                  onChanged: (v) => setState(() {
                    v ? selected.add(c.id) : selected.remove(c.id);
                  }),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(kPagePadding, 8, kPagePadding, 16),
          child: GlowButton(
            label: selected.isEmpty
                ? 'Select at least one calendar'
                : 'Continue',
            busy: _saving,
            onPressed: selected.isEmpty ? null : () => _continue(calendars),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(kPagePadding, 28, kPagePadding, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your calendars',
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Select the calendars you want to see in the app.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarTile extends StatelessWidget {
  const _CalendarTile({
    required this.calendar,
    required this.selected,
    required this.onChanged,
  });

  final GoogleCalendarInfo calendar;
  final bool selected;
  final ValueChanged<bool> onChanged;

  IconData get _icon {
    if (calendar.isBirthdayCalendar) return Icons.cake_outlined;
    if (calendar.isHolidayCalendar) return Icons.card_giftcard_rounded;
    if (calendar.isPrimary) return Icons.calendar_today_outlined;
    return Icons.event_note_outlined;
  }

  String get _subtitle {
    final access = calendar.isWritable ? 'You can edit' : 'Read-only';
    return calendar.isPrimary ? 'Primary · $access' : access;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(calendar.color);
    return Semantics(
      checked: selected,
      label: '${calendar.name}, $_subtitle',
      excludeSemantics: true,
      child: SoftCard(
        onTap: () => onChanged(!selected),
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        child: Row(
          children: [
            IconBadge(icon: _icon, color: color, size: 46),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    calendar.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: selected,
                onChanged: (v) => onChanged(v ?? false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.onSkip,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(kPagePadding),
      child: Column(
        children: [
          const Spacer(),
          Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text('Couldn\'t load calendars', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          GlowButton(label: 'Try again', onPressed: onRetry),
          const SizedBox(height: 8),
          TextButton(onPressed: onSkip, child: const Text('Continue offline')),
        ],
      ),
    );
  }
}
