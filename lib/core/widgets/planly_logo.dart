import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// The Planly app icon: blue-to-teal tile with binder tabs and a 3x3 grid of
/// colored day dots.
class PlanlyLogo extends StatelessWidget {
  const PlanlyLogo({super.key, this.size = 104});

  final double size;

  static const _dots = [
    Colors.white, Color(0xFFFFB950), Colors.white, //
    Color(0xFFFF5D71), Colors.white, Color(0xFFA869FC), //
    Colors.white, Color(0xFF2DD39C), Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    final dot = size * 0.13;
    final gap = size * 0.1;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.logoGradient,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF337CF3).withValues(alpha: 0.28),
            blurRadius: size * 0.35,
            offset: Offset(0, size * 0.12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Binder tabs.
          for (final dx in [-1.0, 1.0])
            Positioned(
              top: size * 0.17,
              left: size / 2 + dx * size * 0.23 - dot * 0.35,
              child: Container(
                width: dot * 0.7,
                height: dot * 0.95,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(dot),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.only(top: size * 0.1),
            child: SizedBox(
              width: dot * 3 + gap * 2,
              child: Wrap(
                spacing: gap,
                runSpacing: gap * 0.75,
                children: [
                  for (final c in _dots)
                    Container(
                      width: dot,
                      height: dot,
                      decoration: BoxDecoration(
                        color: c,
                        borderRadius: BorderRadius.circular(dot * 0.36),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small solid badge shown next to tab titles (design: blue calendar tile).
class PlanlyBadge extends StatelessWidget {
  const PlanlyBadge({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.event_available_rounded,
        color: Colors.white,
        size: size * 0.55,
      ),
    );
  }
}
