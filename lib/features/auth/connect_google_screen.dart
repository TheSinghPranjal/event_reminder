import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/google_logo.dart';
import '../../core/widgets/soft_card.dart';
import '../../core/widgets/stub_notice.dart';
import '../../data/providers.dart';
import 'google_connect_controller.dart';

/// "Connect your calendar": Google sign-in, or continue locally.
class ConnectGoogleScreen extends ConsumerWidget {
  const ConnectGoogleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final connect = ref.watch(googleConnectControllerProvider);
    final controller = ref.read(googleConnectControllerProvider.notifier);
    final isStub = ref.watch(googleAuthServiceProvider).isStub;

    Future<void> signIn() async {
      if (await controller.signIn() && context.mounted) {
        context.go(Routes.calendarPermission);
      }
    }

    Future<void> skip() async {
      await controller.skip();
      if (context.mounted) context.go(Routes.home);
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
                    const SizedBox(height: 32),
                    Container(
                      width: 76,
                      height: 76,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark ? scheme.surfaceContainer : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: scheme.outlineVariant),
                        boxShadow: AppShadows.card(theme.brightness),
                      ),
                      child: const GoogleLogo(size: 42),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Connect your calendar',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sign in with Google to bring your events and birthdays '
                      'into the app.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 24),
                    const _FeatureList(),
                    const Spacer(),
                    const SizedBox(height: 24),
                    if (isStub) ...[
                      const StubNotice(
                        message:
                            'Google Sign-In isn\'t configured yet. You\'ll be '
                            'connected to a labelled test account and no real '
                            'Google data will be read.',
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (connect.message != null) ...[
                      _Message(
                        text: connect.message!,
                        isError: connect.status == ConnectStatus.failed,
                      ),
                      const SizedBox(height: 16),
                    ],
                    GlowButton(
                      label: connect.status == ConnectStatus.idle
                          ? 'Continue with Google'
                          : 'Try again with Google',
                      leading: const GoogleLogoBadge(),
                      busy: connect.isWorking,
                      onPressed: signIn,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: connect.isWorking ? null : skip,
                      child: const Text('Use app without Google'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your calendar data stays between this app and Google '
                      'Calendar. No custom backend is used.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? scheme.onSurfaceVariant
                            : AppColors.textSubtle,
                      ),
                    ),
                    const SizedBox(height: 16),
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

class _FeatureList extends StatelessWidget {
  const _FeatureList();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? scheme.surfaceContainerLow : const Color(0xFFF9FBFD),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: const Column(
        children: [
          _FeatureRow(
            icon: Icons.calendar_today_rounded,
            color: AppColors.primary,
            label: 'View your events',
          ),
          SizedBox(height: 10),
          _FeatureRow(
            icon: Icons.cake_rounded,
            color: Color(0xFFEC4899),
            label: 'See upcoming birthdays',
          ),
          SizedBox(height: 10),
          _FeatureRow(
            icon: Icons.sync_rounded,
            color: Color(0xFF6366F1),
            label: 'Keep everything in sync',
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.color,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          IconBadge(icon: icon, color: color, size: 42),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.isError});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError ? scheme.errorContainer : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline_rounded : Icons.info_outline_rounded,
            size: 18,
            color: isError ? scheme.onErrorContainer : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isError
                    ? scheme.onErrorContainer
                    : scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
