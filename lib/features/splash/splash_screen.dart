import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/widgets/planly_logo.dart';
import '../../data/providers.dart';

/// Opens the local database (running migrations) and decides where to go.
final launchDestinationProvider = FutureProvider.autoDispose<String>((
  ref,
) async {
  final onboarded = await ref
      .read(settingsRepositoryProvider)
      .isOnboardingCompleted();
  return onboarded ? Routes.home : Routes.onboarding;
});

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Doubles as the minimum time the splash stays up.
  late final _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..addStatusListener((_) => _maybeLeave());

  late final _logoScale = Tween(begin: 0.72, end: 1.0).animate(
    CurvedAnimation(
      parent: _intro,
      curve: const Interval(0, 0.55, curve: Curves.easeOutBack),
    ),
  );
  late final _logoFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0, 0.35, curve: Curves.easeOut),
  );
  late final _textFade = CurvedAnimation(
    parent: _intro,
    curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
  );

  bool _left = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _intro.value = 1;
    } else if (_intro.isDismissed) {
      _intro.forward();
    }
  }

  void _maybeLeave() {
    final destination = ref.read(launchDestinationProvider).value;
    if (_left || !_intro.isCompleted || destination == null || !mounted) {
      return;
    }
    _left = true;
    context.go(destination);
  }

  @override
  void dispose() {
    _logoFade.dispose();
    _textFade.dispose();
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final launch = ref.watch(launchDestinationProvider);
    ref.listen(launchDestinationProvider, (_, _) => _maybeLeave());

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: const PlanlyLogo(size: 108),
                    ),
                  ),
                  const SizedBox(height: 36),
                  FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        Text(
                          'Planly',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 36,
                            letterSpacing: -1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your day, organized.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 17,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 56,
              child: launch.hasError
                  ? _LaunchError(
                      onRetry: () => ref.invalidate(launchDestinationProvider),
                    )
                  : Center(
                      child: Semantics(
                        label: 'Loading',
                        child: const SizedBox.square(
                          dimension: 26,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LaunchError extends StatelessWidget {
  const _LaunchError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Planly couldn\'t open its local storage.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
        const SizedBox(height: 8),
        TextButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}
