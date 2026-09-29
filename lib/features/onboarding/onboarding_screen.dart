import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../app/theme/app_theme.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/google_logo.dart';
import '../../core/widgets/page_dots.dart';
import '../auth/google_connect_controller.dart';
import 'widgets/illustrations.dart';
import 'widgets/motion.dart';

class _Page {
  const _Page(this.title, this.body, this.illustration);

  final String title;
  final String body;
  final Widget illustration;
}

const _pages = [
  _Page(
    'Your day,\norganized.',
    'Keep reminders, events and important dates together in one '
        'beautiful place.',
    OrganizedDayIllustration(),
  ),
  _Page(
    'Everything from\nyour calendar.',
    'Connect Google Calendar and see your events, birthdays and '
        'schedules in one place.',
    CalendarCardsIllustration(),
  ),
  _Page(
    'Never miss\nan important moment.',
    'Get timely reminders for meetings, tasks, birthdays and everything '
        'that matters.',
    ImportantMomentsIllustration(),
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pager = PageController();
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  void _next() => _pager.nextPage(
    duration: const Duration(milliseconds: 380),
    curve: Curves.easeOutCubic,
  );

  Future<void> _continueWithGoogle() async {
    final ok = await ref
        .read(googleConnectControllerProvider.notifier)
        .signIn();
    if (ok && mounted) context.go(Routes.calendarPermission);
  }

  Future<void> _continueWithoutGoogle() async {
    await ref.read(googleConnectControllerProvider.notifier).skip();
    if (mounted) context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final connect = ref.watch(googleConnectControllerProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pager,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) => _OnboardingPage(page: _pages[i]),
              ),
            ),
            PageDots(count: _pages.length, index: _index),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kPagePadding + 4),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: _isLast
                    ? Column(
                        children: [
                          if (connect.message != null) ...[
                            Text(
                              connect.message!,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: connect.status == ConnectStatus.failed
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          GlowButton(
                            label: 'Continue with Google',
                            leading: const GoogleLogoBadge(),
                            busy: connect.isWorking,
                            onPressed: _continueWithGoogle,
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton(
                            onPressed: connect.isWorking
                                ? null
                                : _continueWithoutGoogle,
                            child: const Text('Continue without Google'),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'You can connect Google Calendar later.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      )
                    : Column(
                        children: [
                          GlowButton(label: 'Continue', onPressed: _next),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => context.go(Routes.connect),
                            child: const Text('Skip'),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.page});

  final _Page page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPagePadding + 12),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: page.illustration,
              ),
            ),
          ),
          EntranceTransition(
            delay: const Duration(milliseconds: 120),
            offset: const Offset(0, 16),
            child: Column(
              children: [
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge,
                ),
                const SizedBox(height: 14),
                Text(
                  page.body,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
