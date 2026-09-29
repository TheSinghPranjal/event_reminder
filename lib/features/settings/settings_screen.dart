import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/google_logo.dart';
import '../../core/widgets/planly_header.dart';
import '../../core/widgets/soft_card.dart';
import '../sync/providers/account_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final account = ref.watch(activeAccountProvider).value;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const PlanlyHeader(title: 'Settings'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  kPagePadding,
                  8,
                  kPagePadding,
                  32,
                ),
                children: [
                  _Tile(
                    leading: const GoogleLogo(size: 24),
                    leadingColor: scheme.surfaceContainer,
                    title: 'Google Account',
                    subtitle: account == null
                        ? 'Not connected'
                        : account.isStub
                        ? '${account.email} (developer stub)'
                        : account.email,
                    onTap: account == null
                        ? () => context.push(Routes.connect)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _Tile(
                    leading: Icon(
                      Icons.category_rounded,
                      color: scheme.primary,
                    ),
                    leadingColor: scheme.primaryContainer,
                    title: 'Categories',
                    subtitle: 'Default and custom event categories',
                    onTap: () => context.go(Routes.settingsCategories),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.leading,
    required this.leadingColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final Widget leading;
  final Color leadingColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SoftCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: leadingColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: leading,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}
