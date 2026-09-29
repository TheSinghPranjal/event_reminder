import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/google_logo.dart';
import '../../core/widgets/planly_header.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../core/widgets/soft_card.dart';
import '../../data/local/app_database.dart';
import '../../data/providers.dart';
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
                  if (account == null)
                    _Tile(
                      leading: const GoogleLogo(size: 24),
                      leadingColor: scheme.surfaceContainer,
                      title: 'Google Account',
                      subtitle: 'Not connected',
                      onTap: () => context.push(Routes.connect),
                    )
                  else
                    SoftCard(
                      onTap: () => _showAccountSheet(context, ref, account),
                      child: Row(
                        children: [
                          ProfileAvatar(account: account, radius: 22),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.displayName?.trim().isNotEmpty == true
                                      ? account.displayName!
                                      : 'Google Account',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  account.isStub
                                      ? '${account.email} (developer stub)'
                                      : account.email,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  account.calendarAccessGranted
                                      ? 'Calendar access granted'
                                      : 'Calendar access not granted',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: account.calendarAccessGranted
                                        ? scheme.tertiary
                                        : scheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: scheme.onSurfaceVariant,
                          ),
                        ],
                      ),
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

  Future<void> _showAccountSheet(
    BuildContext context,
    WidgetRef ref,
    LinkedAccount account,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.sync_rounded),
                  title: const Text('Sync now'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    context.push(Routes.initialSync);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.link_off_rounded,
                    color: Theme.of(sheetContext).colorScheme.error,
                  ),
                  title: Text(
                    'Disconnect',
                    style: TextStyle(
                      color: Theme.of(sheetContext).colorScheme.error,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    await ref
                        .read(accountRepositoryProvider)
                        .disconnect(account.id);
                    await ref.read(googleAuthServiceProvider).signOut();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Google account disconnected')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
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
