import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../category_icons.dart';
import '../providers/categories_providers.dart';
import 'category_badge.dart';

Future<void> showCreateCategorySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => const CreateCategorySheet(),
  );
}

/// Create Custom Category: name, icon and color with a live preview.
class CreateCategorySheet extends ConsumerStatefulWidget {
  const CreateCategorySheet({super.key});

  @override
  ConsumerState<CreateCategorySheet> createState() =>
      _CreateCategorySheetState();
}

class _CreateCategorySheetState extends ConsumerState<CreateCategorySheet> {
  final _name = TextEditingController();
  String _iconKey = 'star';
  int _color = customCategoryColors.first;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  String? _validate(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Give your category a name';
    final existing = ref.read(categoriesProvider).value ?? const [];
    final taken = existing.any(
      (c) => c.name.toLowerCase() == trimmed.toLowerCase(),
    );
    return taken ? 'A category with this name already exists' : null;
  }

  Future<void> _save() async {
    final error = _validate(_name.text);
    setState(() => _error = error);
    if (error != null) return;

    setState(() => _saving = true);
    try {
      await ref
          .read(categoryRepositoryProvider)
          .createCustom(name: _name.text, iconKey: _iconKey, color: _color);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Could not save category';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CategoryBadge(
                  iconKey: _iconKey,
                  color: Color(_color),
                  size: 52,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'New category',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _name,
              autofocus: true,
              maxLength: 40,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: _error,
                counterText: '',
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 20),
            Text('Icon', style: theme.textTheme.titleSmall),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in categoryIcons.entries)
                  _Choice(
                    selected: entry.key == _iconKey,
                    color: Color(_color),
                    onTap: () => setState(() => _iconKey = entry.key),
                    child: Icon(
                      entry.value,
                      size: 22,
                      color: entry.key == _iconKey
                          ? Color(_color)
                          : scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Color', style: theme.textTheme.titleSmall),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final c in customCategoryColors)
                  Semantics(
                    button: true,
                    selected: c == _color,
                    label: 'Color',
                    child: GestureDetector(
                      onTap: () => setState(() => _color = c),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Color(c),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: c == _color
                                ? scheme.onSurface
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: c == _color
                            ? const Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create category'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.selected,
    required this.color,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final Color color;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.12) : scheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color : scheme.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
