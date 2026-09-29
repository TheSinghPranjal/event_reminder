import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Google "G" mark drawn in brand colors.
///
/// TODO(phase 7): swap for the official asset from Google's sign-in branding
/// kit when real Google Sign-In ships.
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: const CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  const _GooglePainter();

  static double _rad(double deg) => deg * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = size.width * 0.22;
    final rect = Rect.fromLTWH(
      stroke / 2,
      stroke / 2,
      size.width - stroke,
      size.height - stroke,
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    void arc(Color c, double from, double sweep) =>
        canvas.drawArc(rect, _rad(from), _rad(sweep), false, paint..color = c);

    // Angles are clockwise from 3 o'clock.
    arc(AppColors.googleRed, -140, 97);
    arc(AppColors.googleYellow, 145, 76);
    arc(AppColors.googleGreen, 40, 106);
    arc(AppColors.googleBlue, 0, 41);

    // The crossbar.
    final bar = Paint()..color = AppColors.googleBlue;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.5,
        size.height / 2 - stroke / 2,
        size.width * 0.5 - stroke * 0.05,
        stroke,
      ),
      bar,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// White circle holding the G, used inside blue buttons.
class GoogleLogoBadge extends StatelessWidget {
  const GoogleLogoBadge({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.18),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: GoogleLogo(size: size * 0.64),
    );
  }
}
