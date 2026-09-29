import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/app_database.dart';
import '../providers/categories_providers.dart';
import '../../../core/widgets/soft_card.dart';
import 'category_badge.dart';
import 'create_category_sheet.dart';

/// Two-column grid of all categories (built-in + custom).
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Event Categories')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCreateCategorySheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New category'),
      ),
      body: switch (categories) {
        AsyncData(:final value) => GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemCount: value.length,
          itemBuilder: (context, i) => _CategoryTile(category: value[i]),
        ),
        AsyncError(:final error) => Center(
          child: Text('Could not load categories.\n$error'),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});

  final EventCategory category;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = Color(category.color);

    // Tapping will open the category's filtered event list once events exist.
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CategoryBadge(iconKey: category.iconKey, color: color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category.name,
                style: theme.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (!category.isBuiltIn)
                Text(
                  'Custom',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
