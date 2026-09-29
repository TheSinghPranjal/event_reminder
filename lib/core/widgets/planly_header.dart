import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../features/sync/providers/account_providers.dart';
import 'planly_logo.dart';
import 'profile_avatar.dart';

/// Top bar shared by the tab screens: badge + title, sync and profile.
class PlanlyHeader extends ConsumerWidget {
  const PlanlyHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final account = ref.watch(activeAccountProvider).value;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(kPagePadding, 12, 12, 8),
      child: Row(
        children: [
          const PlanlyBadge(size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.headlineMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: account == null ? 'Connect Google Calendar' : 'Sync',
            onPressed: () => context.push(
              account == null ? Routes.connect : Routes.initialSync,
            ),
            icon: Icon(
              Icons.sync_rounded,
              color: isDark ? const Color(0xFF34D399) : AppColors.successDeep,
            ),
          ),
          const SizedBox(width: 4),
          ProfileAvatar(
            account: account,
            onTap: () => context.go(Routes.settings),
          ),
        ],
      ),
    );
  }
}
