import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import 'motion.dart';

/// All illustrations are laid out on a fixed 320x300 canvas and scaled to fit.
class _Canvas extends StatelessWidget {
  const _Canvas({required this.children, this.glow});

  final List<Widget> children;
  final Color? glow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Artwork: sized as a whole, so OS text scaling must not distort it.
    return MediaQuery.withNoTextScaling(
      child: ExcludeSemantics(
        child: FittedBox(
          child: SizedBox(
            width: 320,
            height: 300,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          (glow ?? const Color(0xFFE0E7FF)).withValues(
                            alpha: isDark ? 0.12 : 0.55,
                          ),
                          (glow ?? const Color(0xFFE0E7FF)).withValues(
                            alpha: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _cardColor(BuildContext context) => Theme.of(context).colorScheme.surface;

List<BoxShadow> _shadow(BuildContext context, {double blur = 30}) =>
    Theme.of(context).brightness == Brightness.dark
    ? const []
    : [
        BoxShadow(
          color: const Color(0xFF1E3A8A).withValues(alpha: 0.10),
          blurRadius: blur,
          offset: const Offset(0, 12),
        ),
      ];

class _Sparkle extends StatelessWidget {
  const _Sparkle(this.color, this.size, {this.star = false});

  final Color color;
  final double size;
  final bool star;

  @override
  Widget build(BuildContext context) => Icon(
    star ? Icons.star_rounded : Icons.auto_awesome,
    color: color,
    size: size,
  );
}

class _Dot extends StatelessWidget {
  const _Dot(this.color, this.size);

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

// ---------------------------------------------------------------------------
// 1. "Your day, organized." Calendar with a bell tile and a clock.
// ---------------------------------------------------------------------------

class OrganizedDayIllustration extends StatelessWidget {
  const OrganizedDayIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pill = isDark ? const Color(0xFF26324F) : const Color(0xFFEEF2FF);

    return _Canvas(
      children: [
        // Calendar card.
        Positioned(
          left: 68,
          top: 40,
          child: Transform.rotate(
            angle: -0.03,
            child: Container(
              width: 190,
              height: 206,
              decoration: BoxDecoration(
                color: _cardColor(context),
                borderRadius: BorderRadius.circular(22),
                boxShadow: _shadow(context),
              ),
              padding: const EdgeInsets.fromLTRB(18, 44, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 11,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2B3A66)
                          : const Color(0xFFE0E7FF),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 22),
                  for (var row = 0; row < 3; row++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 9),
                      child: Row(
                        children: [
                          for (var col = 0; col < 3; col++) ...[
                            Expanded(
                              child: Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  color: row == 1 && col == 1
                                      ? AppColors.primary
                                      : pill,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            if (col < 2) const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                  const Spacer(),
                  FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Container(
                      height: 7,
                      decoration: BoxDecoration(
                        color: pill,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Binder rings.
        for (final left in [117.0, 196.0])
          Positioned(
            left: left,
            top: 32,
            child: Container(
              width: 10,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFC7D2FE), Color(0xFF818CF8)],
                ),
              ),
            ),
          ),
        // Bell tile.
        Positioned(
          left: 14,
          top: 44,
          child: Floating(
            phase: 0.1,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFCD34D), Color(0xFFFB923C)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFB923C).withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
          ),
        ),
        // Clock.
        const Positioned(
          left: 224,
          top: 176,
          child: Floating(phase: 0.55, child: _Clock()),
        ),
        const Positioned(
          left: 72,
          top: 14,
          child: _Sparkle(Color(0xFFFBBF24), 18),
        ),
        const Positioned(
          left: 258,
          top: 46,
          child: _Sparkle(Color(0xFFF472B6), 16, star: true),
        ),
        const Positioned(
          left: 16,
          top: 146,
          child: _Dot(Color(0xFFD8B4FE), 13),
        ),
        const Positioned(
          left: 96,
          top: 262,
          child: _Sparkle(Color(0xFF7F8AF5), 16),
        ),
      ],
    );
  }
}

class _Clock extends StatelessWidget {
  const _Clock();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: _cardColor(context),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4D65EF).withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6366F1), Color(0xFF2563EB)],
          ),
        ),
        child: const CustomPaint(painter: _ClockHandsPainter()),
      ),
    );
  }
}

class _ClockHandsPainter extends CustomPainter {
  const _ClockHandsPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final hand = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(c.dx, size.height * 0.1),
      Offset(c.dx, c.dy * 0.55),
      hand,
    );
    canvas.drawLine(Offset(c.dx + 12, c.dy), Offset(c.dx + 24, c.dy), hand);
    canvas.drawCircle(c, 5, Paint()..color = const Color(0xFFFCD34D));
    canvas.drawCircle(
      Offset(c.dx, size.height * 0.85),
      1.8,
      Paint()..color = Colors.white.withValues(alpha: 0.6),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// 2. "Everything from your calendar." Stacked calendar card with chips.
// ---------------------------------------------------------------------------

class CalendarCardsIllustration extends StatelessWidget {
  const CalendarCardsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();

    return _Canvas(
      glow: const Color(0xFFD1FAE5),
      children: [
        // "Birthdays" chip, tucked behind the cards.
        const Positioned(
          left: 5,
          top: 26,
          child: EntranceTransition(
            delay: Duration(milliseconds: 250),
            offset: Offset(-20, 0),
            child: _Chip(dot: Color(0xFFFF5D71), label: 'Birthdays'),
          ),
        ),
        // Back card, for the stacked look.
        Positioned(
          left: 48,
          top: 44,
          child: EntranceTransition(
            delay: const Duration(milliseconds: 100),
            child: Transform.rotate(
              angle: -0.07,
              child: Container(
                width: 190,
                height: 205,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1A2440)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: _shadow(context, blur: 20),
                ),
              ),
            ),
          ),
        ),
        // Front card.
        Positioned(
          left: 60,
          top: 38,
          child: EntranceTransition(
            delay: const Duration(milliseconds: 200),
            offset: const Offset(0, 36),
            child: Container(
              width: 202,
              height: 218,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              decoration: BoxDecoration(
                color: _cardColor(context),
                borderRadius: BorderRadius.circular(24),
                boxShadow: _shadow(context),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF26324F)
                      : const Color(0xFFF1F5F9),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DateBadge(date: now),
                      const Spacer(),
                      const _Dot(Color(0xFFE2E8F0), 7),
                      const SizedBox(width: 4),
                      const _Dot(Color(0xFFE2E8F0), 7),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const _EventRow(
                    icon: Icons.event_available_rounded,
                    color: AppColors.primary,
                    title: 'Design Review',
                    subtitle: '10:00 - 11:30 AM',
                    highlighted: true,
                  ),
                  const SizedBox(height: 7),
                  const _EventRow(
                    icon: Icons.cake_rounded,
                    color: AppColors.success,
                    title: "Alex's Birthday",
                    subtitle: 'All day',
                  ),
                  const Spacer(),
                  Divider(
                    height: 1,
                    color: isDark
                        ? const Color(0xFF26324F)
                        : const Color(0xFFF1F5F9),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Google Calendar',
                        style: TextStyle(
                          fontSize: 9,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.sync_rounded,
                        size: 11,
                        color: AppColors.success,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        // Checkmark pill.
        Positioned(
          left: 236,
          top: 0,
          child: Floating(
            phase: 0.3,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
              decoration: BoxDecoration(
                color: _cardColor(context),
                borderRadius: BorderRadius.circular(30),
                boxShadow: _shadow(context, blur: 16),
              ),
              child: Row(
                children: [
                  const _Dot(Color(0xFF3B82F6), 9),
                  const SizedBox(width: 8),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 220,
          top: 222,
          child: Floating(
            phase: 0.7,
            child: _Chip(dot: AppColors.success, label: 'Personal'),
          ),
        ),
        const Positioned(
          left: 34,
          top: 240,
          child: Floating(
            phase: 0.45,
            child: _Chip(
              icon: Icons.sync_rounded,
              label: 'Auto-sync',
              small: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        gradient: AppColors.tileGradient,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${date.day}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            DateFormat('EEE').format(date).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 7,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.highlighted = false,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: highlighted
            ? (isDark ? const Color(0xFF1B2C57) : const Color(0xFFEFF6FF))
            : (isDark ? const Color(0xFF1A2440) : const Color(0xFFF8FAFC)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted
              ? (isDark ? const Color(0xFF2B3F7A) : const Color(0xFFDBEAFE))
              : (isDark ? const Color(0xFF26324F) : const Color(0xFFF1F5F9)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 15),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 8, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.dot, this.icon, this.small = false});

  final String label;
  final Color? dot;
  final IconData? icon;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 11 : 14,
        vertical: small ? 7 : 9,
      ),
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(30),
        boxShadow: _shadow(context, blur: 14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot != null) _Dot(dot!, 10),
          if (icon != null) Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: small ? 10 : 12,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. "Never miss an important moment." Person with reminder badges.
// ---------------------------------------------------------------------------

class ImportantMomentsIllustration extends StatelessWidget {
  const ImportantMomentsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _Canvas(
      glow: const Color(0xFFFEF3C7),
      children: [
        Positioned(
          left: 41,
          top: 31,
          child: Container(
            width: 238,
            height: 238,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? const [Color(0xFF2A2415), Color(0xFF332A12)]
                    : const [Color(0xFFFFF7EC), Color(0xFFFEF3C7)],
              ),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF3F3417)
                    : const Color(0xFFFDE9C4),
              ),
            ),
          ),
        ),
        // Person, clipped to the bottom of the circle.
        Positioned(
          left: 41,
          top: 31,
          child: ClipOval(
            child: SizedBox(
              width: 238,
              height: 238,
              child: Stack(
                children: [
                  Positioned(
                    left: 64,
                    top: 50,
                    child: SizedBox(
                      width: 110,
                      height: 160,
                      child: CustomPaint(painter: _PersonPainter()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 20,
          top: 50,
          child: Floating(
            phase: 0.15,
            child: _BadgeTile(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF3F2E10)
                      : const Color(0xFFFFF4E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications_rounded,
                  color: Color(0xFFF59E0B),
                  size: 22,
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 212,
          top: 16,
          child: Floating(
            phase: 0.6,
            child: _BadgeTile(
              borderColor: Color(0xFFFBCFE8),
              child: Icon(
                Icons.cake_rounded,
                color: Color(0xFFEC4899),
                size: 28,
              ),
            ),
          ),
        ),
        Positioned(
          left: 236,
          top: 120,
          child: Floating(
            phase: 0.35,
            amplitude: 4,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        const Positioned(left: 94, top: 22, child: _Dot(Color(0xFFA0C8FA), 9)),
        const Positioned(left: 275, top: 86, child: _Dot(Color(0xFFF7A9D2), 7)),
        const Positioned(
          left: 60,
          top: 222,
          child: _Dot(Color(0xFFFCD162), 11),
        ),
      ],
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.child, this.borderColor});

  final Widget child;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _cardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor ?? const Color(0xFFFDE9C4),
          width: 1.2,
        ),
        boxShadow: _shadow(context, blur: 16),
      ),
      child: child,
    );
  }
}

/// A friendly, smiling person drawn from simple shapes.
class _PersonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const hair = Color(0xFF2E334D);
    const skin = Color(0xFFFEE1C0);
    const shirt = Color(0xFF3B82F6);

    // Long hair behind the head and shoulders.
    final back = RRect.fromRectAndCorners(
      Rect.fromLTWH(w * 0.1, h * 0.02, w * 0.8, h * 0.72),
      topLeft: Radius.circular(w * 0.4),
      topRight: Radius.circular(w * 0.4),
      bottomLeft: Radius.circular(w * 0.12),
      bottomRight: Radius.circular(w * 0.12),
    );
    canvas.drawRRect(back, Paint()..color = hair);

    // Shirt.
    final body = Path()
      ..moveTo(w * 0.3, h * 0.66)
      ..lineTo(w * 0.7, h * 0.66)
      ..lineTo(w * 1.02, h * 1.02)
      ..lineTo(-w * 0.02, h * 1.02)
      ..close();
    canvas.drawPath(body, Paint()..color = shirt);

    // Neck.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.42, h * 0.52, w * 0.16, h * 0.18),
        Radius.circular(w * 0.08),
      ),
      Paint()..color = skin,
    );

    // Ears and face.
    final skinPaint = Paint()..color = skin;
    canvas.drawCircle(Offset(w * 0.21, h * 0.38), w * 0.07, skinPaint);
    canvas.drawCircle(Offset(w * 0.79, h * 0.38), w * 0.07, skinPaint);
    canvas.drawOval(
      Rect.fromLTWH(w * 0.22, h * 0.16, w * 0.56, h * 0.42),
      skinPaint,
    );

    // Bangs.
    final bangs = Path()
      ..moveTo(w * 0.2, h * 0.34)
      ..quadraticBezierTo(w * 0.2, h * 0.08, w * 0.5, h * 0.08)
      ..quadraticBezierTo(w * 0.8, h * 0.08, w * 0.8, h * 0.34)
      ..quadraticBezierTo(w * 0.7, h * 0.22, w * 0.5, h * 0.24)
      ..quadraticBezierTo(w * 0.3, h * 0.24, w * 0.2, h * 0.34)
      ..close();
    canvas.drawPath(bangs, Paint()..color = hair);

    // Smiling closed eyes.
    final line = Paint()
      ..color = hair
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    for (final x in [0.38, 0.62]) {
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(w * x, h * 0.38),
          width: w * 0.11,
          height: h * 0.05,
        ),
        math.pi,
        math.pi,
        false,
        line,
      );
    }

    // Blush.
    final blush = Paint()
      ..color = const Color(0xFFFCA5A5).withValues(alpha: 0.7);
    for (final x in [0.32, 0.68]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * x, h * 0.44),
          width: w * 0.09,
          height: h * 0.03,
        ),
        blush,
      );
    }

    // Smile.
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.44),
        width: w * 0.14,
        height: h * 0.07,
      ),
      0.15,
      math.pi - 0.3,
      false,
      line..color = const Color(0xFFB45309),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
