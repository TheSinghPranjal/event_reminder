import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/soft_card.dart';
import '../../data/providers.dart';
import '../../data/repositories/event_repository.dart';
import '../../services/event_push_service.dart';
import '../categories/providers/categories_providers.dart';
import '../sync/providers/account_providers.dart';
import 'event_providers.dart';

class EventEditorScreen extends ConsumerStatefulWidget {
  const EventEditorScreen({super.key, this.eventId});

  /// Null means create; non-null means edit.
  final int? eventId;

  @override
  ConsumerState<EventEditorScreen> createState() => _EventEditorScreenState();
}

class _EventEditorScreenState extends ConsumerState<EventEditorScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _location = TextEditingController();

  DateTime _startsAt = DateTime.now().add(const Duration(hours: 1));
  DateTime _endsAt = DateTime.now().add(const Duration(hours: 2));
  bool _isAllDay = false;
  int? _categoryId;
  int? _calendarId;
  int? _reminderMinutes = 30;
  bool _loaded = false;
  bool _saving = false;
  bool _readOnly = false;
  String? _readOnlyReason;
  String? _error;

  bool get _isEditing => widget.eventId != null;

  @override
  void initState() {
    super.initState();
    _startsAt = DateTime(
      _startsAt.year,
      _startsAt.month,
      _startsAt.day,
      _startsAt.hour,
    );
    _endsAt = _startsAt.add(const Duration(hours: 1));
    if (widget.eventId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _defaultCalendar());
    }
  }

  Future<void> _defaultCalendar() async {
    final calendars = await ref.read(writableCalendarsProvider.future);
    if (!mounted) return;
    setState(() {
      _calendarId = calendars.where((c) => c.isPrimary).firstOrNull?.id ??
          calendars.firstOrNull?.id;
      _loaded = true;
    });
  }

  Future<void> _loadExisting() async {
    final view = await ref
        .read(eventRepositoryProvider)
        .watchView(widget.eventId!)
        .first;
    if (!mounted) return;
    if (view == null) {
      setState(() {
        _loaded = true;
        _error = 'This event no longer exists.';
      });
      return;
    }
    final e = view.event;
    final calendar = view.calendar;
    final writable = calendar == null ||
        calendar.accessRole == 'owner' ||
        calendar.accessRole == 'writer';
    _title.text = e.title;
    _description.text = e.description ?? '';
    _location.text = e.location ?? '';
    setState(() {
      _startsAt = e.startsAt.toLocal();
      _endsAt = e.endsAt.toLocal();
      _isAllDay = e.isAllDay;
      _categoryId = e.categoryId;
      _calendarId = e.calendarId;
      _reminderMinutes = e.reminderMinutes;
      _readOnly = !writable;
      _readOnlyReason = writable
          ? null
          : 'This calendar is read-only, so the event can\'t be edited.';
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startsAt : _endsAt;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        final duration = _endsAt.difference(_startsAt);
        _startsAt = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _startsAt.hour,
          _startsAt.minute,
        );
        _endsAt = _startsAt.add(duration);
      } else {
        _endsAt = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _endsAt.hour,
          _endsAt.minute,
        );
      }
    });
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _startsAt : _endsAt;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        final duration = _endsAt.difference(_startsAt);
        _startsAt = DateTime(
          _startsAt.year,
          _startsAt.month,
          _startsAt.day,
          picked.hour,
          picked.minute,
        );
        _endsAt = _startsAt.add(duration);
      } else {
        _endsAt = DateTime(
          _endsAt.year,
          _endsAt.month,
          _endsAt.day,
          picked.hour,
          picked.minute,
        );
      }
    });
  }

  EventDraft _draft() {
    final start = _isAllDay
        ? DateTime(_startsAt.year, _startsAt.month, _startsAt.day)
        : _startsAt;
    var end = _isAllDay
        ? DateTime(_endsAt.year, _endsAt.month, _endsAt.day)
        : _endsAt;
    if (_isAllDay && !end.isAfter(start)) {
      end = start.add(const Duration(days: 1));
    }
    return EventDraft(
      title: _title.text.trim(),
      description: _description.text.trim().isEmpty
          ? null
          : _description.text.trim(),
      location: _location.text.trim().isEmpty ? null : _location.text.trim(),
      startsAt: start,
      endsAt: end,
      isAllDay: _isAllDay,
      reminderMinutes: _reminderMinutes,
      categoryId: _categoryId,
      calendarId: _calendarId,
    );
  }

  Future<void> _save() async {
    if (_readOnly || _saving) return;
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Title is required.');
      return;
    }
    final draft = _draft();
    if (!draft.isAllDay && !draft.endsAt.isAfter(draft.startsAt)) {
      setState(() => _error = 'End must be after start.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final repo = ref.read(eventRepositoryProvider);
      final int id;
      if (_isEditing) {
        id = widget.eventId!;
        await repo.update(id, draft);
      } else {
        id = await repo.create(draft);
      }

      final account = ref.read(activeAccountProvider).value;
      if (account != null &&
          account.calendarAccessGranted &&
          draft.calendarId != null) {
        // Fire-and-forget push; sync screen can retry later.
        unawaited(ref.read(eventPushServiceProvider).pushPending(account.id));
      }

      if (!mounted) return;
      context.go(Routes.eventDetails(id));
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Couldn\'t save the event. Try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final calendars = ref.watch(writableCalendarsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit event' : 'New event'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!_readOnly && _loaded)
            TextButton(
              key: const ValueKey('event-save'),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? 'Save' : 'Create'),
            ),
        ],
      ),
      body: !_loaded
          ? const Center(child: Text('Loading…'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                kPagePadding,
                8,
                kPagePadding,
                32,
              ),
              children: [
                if (_readOnlyReason != null) ...[
                  SoftCard(
                    color: scheme.errorContainer,
                    child: Text(
                      _readOnlyReason!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onErrorContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                TextField(
                  controller: _title,
                  enabled: !_readOnly,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'What\'s happening?',
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('All day'),
                  value: _isAllDay,
                  onChanged: _readOnly
                      ? null
                      : (v) => setState(() => _isAllDay = v),
                ),
                SoftCard(
                  child: Column(
                    children: [
                      _DateTimeRow(
                        label: 'Starts',
                        value: _startsAt,
                        allDay: _isAllDay,
                        onDate: () => _pickDate(isStart: true),
                        onTime: () => _pickTime(isStart: true),
                        enabled: !_readOnly,
                      ),
                      const Divider(height: 24),
                      _DateTimeRow(
                        label: 'Ends',
                        value: _endsAt,
                        allDay: _isAllDay,
                        onDate: () => _pickDate(isStart: false),
                        onTime: () => _pickTime(isStart: false),
                        enabled: !_readOnly,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _location,
                  enabled: !_readOnly,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'Optional',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _description,
                  enabled: !_readOnly,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Optional notes',
                  ),
                ),
                const SizedBox(height: 20),
                Text('Calendar', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Local only'),
                      selected: _calendarId == null,
                      onSelected: _readOnly
                          ? null
                          : (_) => setState(() => _calendarId = null),
                    ),
                    for (final c in calendars)
                      ChoiceChip(
                        label: Text(c.name),
                        selected: _calendarId == c.id,
                        onSelected: _readOnly
                            ? null
                            : (_) => setState(() => _calendarId = c.id),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Category', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('None'),
                      selected: _categoryId == null,
                      onSelected: _readOnly
                          ? null
                          : (_) => setState(() => _categoryId = null),
                    ),
                    for (final c in categories)
                      ChoiceChip(
                        label: Text(c.name),
                        selected: _categoryId == c.id,
                        onSelected: _readOnly
                            ? null
                            : (_) => setState(() => _categoryId = c.id),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<int?>(
                  // ignore: deprecated_member_use
                  value: _reminderMinutes,
                  decoration: const InputDecoration(labelText: 'Reminder'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('None')),
                    DropdownMenuItem(value: 0, child: Text('At time of event')),
                    DropdownMenuItem(value: 5, child: Text('5 minutes before')),
                    DropdownMenuItem(value: 10, child: Text('10 minutes before')),
                    DropdownMenuItem(value: 30, child: Text('30 minutes before')),
                    DropdownMenuItem(value: 60, child: Text('1 hour before')),
                    DropdownMenuItem(value: 1440, child: Text('1 day before')),
                  ],
                  onChanged: _readOnly
                      ? null
                      : (v) => setState(() => _reminderMinutes = v),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.error,
                    ),
                  ),
                ],
                if (!_readOnly) ...[
                  const SizedBox(height: 28),
                  GlowButton(
                    label: _isEditing ? 'Save changes' : 'Create event',
                    busy: _saving,
                    onPressed: _save,
                  ),
                ],
              ],
            ),
    );
  }
}

class _DateTimeRow extends StatelessWidget {
  const _DateTimeRow({
    required this.label,
    required this.value,
    required this.allDay,
    required this.onDate,
    required this.onTime,
    required this.enabled,
  });

  final String label;
  final DateTime value;
  final bool allDay;
  final VoidCallback onDate;
  final VoidCallback onTime;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(label, style: theme.textTheme.labelLarge),
        ),
        Expanded(
          child: TextButton(
            onPressed: enabled ? onDate : null,
            child: Text(DateFormat.yMMMd().format(value)),
          ),
        ),
        if (!allDay)
          TextButton(
            onPressed: enabled ? onTime : null,
            child: Text(DateFormat.jm().format(value)),
          ),
      ],
    );
  }
}
