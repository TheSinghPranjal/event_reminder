import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/stub_notice.dart';
import '../../data/providers.dart';
import '../sync/presentation/sync_illustrations.dart';
import 'google_connect_controller.dart';

/// "Allow calendar access": the separate Calendar authorization step.
class CalendarPermissionScreen extends ConsumerWidget {
  const CalendarPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final connect = ref.watch(googleConnectControllerProvider);
    final isStub = ref.watch(googleAuthServiceProvider).isStub;
    final denied = connect.status == ConnectStatus.cancelled;

    Future<void> allow() async {
      final granted = await ref
          .read(googleConnectControllerProvider.notifier)
          .requestCalendarAccess();
      if (granted && context.mounted) context.go(Routes.selectCalendars);
    }

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kPagePadding + 4,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const SizedBox(
                      height: 200,
                      child: CalendarShieldIllustration(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Allow calendar access',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'This lets the app display your events, birthdays and '
                      'reminders and keep them in sync with Google Calendar.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const _Check('View your events'),
                    const _Check('See birthdays'),
                    const _Check('Create and update events'),
                    const _Check('Keep your data private'),
                    const SizedBox(height: 8),
                    Text(
                      'Planly reads your calendars, and only creates or edits '
                      'events when you ask it to. You can revoke access any '
                      'time in your Google Account.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 24),
                    if (isStub) ...[
                      const StubNotice(
                        message:
                            'No Google permission prompt will appear; access '
                            'is granted to the test account only.',
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (connect.message != null) ...[
                      Text(
                        connect.message!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: connect.status == ConnectStatus.failed
                              ? scheme.error
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    GlowButton(
                      label: denied ? 'Try again' : 'Allow Calendar Access',
                      busy: connect.isWorking,
                      onPressed: allow,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: connect.isWorking
                          ? null
                          : () => context.go(Routes.home),
                      child: Text(denied ? 'Continue locally' : 'Not now'),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  const _Check(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0E3B2E) : AppColors.successSoft,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? const Color(0xFF14532D)
                    : const Color(0xFFBBF7D0),
              ),
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 18,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
