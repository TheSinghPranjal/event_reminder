import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

List<BoxShadow> _blueGlow(double alpha) => [
  BoxShadow(
    color: AppColors.primary.withValues(alpha: alpha),
    blurRadius: 28,
    offset: const Offset(0, 12),
  ),
];

/// Calendar with a security shield (calendar permission screen).
class CalendarShieldIllustration extends StatelessWidget {
  const CalendarShieldIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dot = isDark ? const Color(0xFF2B4A8A) : const Color(0xFFBFDBFE);

    return FittedBox(
      child: SizedBox(
        width: 240,
        height: 190,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 30,
              top: 20,
              child: Container(
                width: 150,
                height: 140,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: scheme.outlineVariant),
                  boxShadow: isDark ? null : _blueGlow(0.12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      height: 34,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 10,
                        children: [
                          for (var i = 0; i < 10; i++)
                            Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                color: i == 5
                                    ? const Color(0xFF93C5FD)
                                    : dot.withValues(alpha: i > 7 ? 0.6 : 1),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            for (final x in [62.0, 99.0, 136.0])
              Positioned(
                left: x,
                top: 10,
                child: Container(
                  width: 9,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF60A5FA),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            Positioned(
              left: 170,
              top: 6,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFF43F5E),
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.surface, width: 3),
                ),
              ),
            ),
            const Positioned(
              left: 14,
              top: 64,
              child: CircleAvatar(
                radius: 5,
                backgroundColor: Color(0xFF93C5FD),
              ),
            ),
            const Positioned(left: 136, top: 70, child: _Shield(size: 82)),
          ],
        ),
      ),
    );
  }
}

class _Shield extends StatelessWidget {
  const _Shield({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.12,
      child: CustomPaint(
        painter: const _ShieldPainter(),
        child: Center(
          child: Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

class _ShieldPainter extends CustomPainter {
  const _ShieldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..quadraticBezierTo(w * 0.72, h * 0.1, w * 0.98, h * 0.12)
      ..lineTo(w * 0.98, h * 0.48)
      ..quadraticBezierTo(w * 0.95, h * 0.82, w * 0.5, h)
      ..quadraticBezierTo(w * 0.05, h * 0.82, w * 0.02, h * 0.48)
      ..lineTo(w * 0.02, h * 0.12)
      ..quadraticBezierTo(w * 0.28, h * 0.1, w * 0.5, 0)
      ..close();
    canvas.drawShadow(path, const Color(0xFF1D4ED8), 10, false);
    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Blue calendar with a "SYNC" panel (initial sync screen). The refresh icon
/// spins only while [active].
class SyncIllustration extends StatefulWidget {
  const SyncIllustration({super.key, required this.active});

  final bool active;

  @override
  State<SyncIllustration> createState() => _SyncIllustrationState();
}

class _SyncIllustrationState extends State<SyncIllustration>
    with SingleTickerProviderStateMixin {
  late final _spin = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _update();
  }

  @override
  void didUpdateWidget(SyncIllustration oldWidget) {
    super.didUpdateWidget(oldWidget);
    _update();
  }

  void _update() {
    if (widget.active && !MediaQuery.disableAnimationsOf(context)) {
      if (!_spin.isAnimating) _spin.repeat();
    } else {
      _spin.stop();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const line = Color(0xFFDBEAFE);
    const lineStrong = Color(0xFF93C5FD);
    return FittedBox(
      child: SizedBox(
        width: 240,
        height: 200,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 40,
              top: 30,
              child: Container(
                width: 150,
                height: 144,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                  ),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: _blueGlow(0.3),
                ),
                padding: const EdgeInsets.fromLTRB(10, 34, 10, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'SYNC',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          const Spacer(),
                          RotationTransition(
                            turns: _spin,
                            child: const Icon(
                              Icons.sync_rounded,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      for (final strong in [2, 1])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            children: [
                              for (var i = 0; i < 4; i++) ...[
                                Expanded(
                                  child: Container(
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: i == strong ? lineStrong : line,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                                if (i < 3) const SizedBox(width: 5),
                              ],
                            ],
                          ),
                        ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.cloud_rounded,
                            size: 13,
                            color: Color(0xFF60A5FA),
                          ),
                          const SizedBox(width: 6),
                          // Decorative only; real progress is shown below
                          // the stage list.
                          Expanded(
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: line,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            for (final x in [62.0, 158.0])
              Positioned(
                left: x,
                top: 38,
                child: Container(
                  width: 10,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            Positioned(
              left: 98,
              top: 44,
              child: Container(
                width: 34,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFBFDBFE),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Positioned(
              left: 164,
              top: 140,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6366F1), Color(0xFF3B5BDB)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: _blueGlow(0.3),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 4,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFFBBF24),
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Glossy check tile with a one-shot confetti burst (setup complete).
class SuccessBurst extends StatefulWidget {
  const SuccessBurst({super.key});

  @override
  State<SuccessBurst> createState() => _SuccessBurstState();
}

class _SuccessBurstState extends State<SuccessBurst>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  );
  late final _tileScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.55, curve: Curves.elasticOut),
  );
  late final _check = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.3, 0.7, curve: Curves.easeOutCubic),
  );
  late final _burst = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.15, 1, curve: Curves.easeOutCubic),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else if (_controller.isDismissed) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _tileScale.dispose();
    _check.dispose();
    _burst.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return FittedBox(
      child: SizedBox(
        width: 300,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(
                      0xFFDBEAFE,
                    ).withValues(alpha: isDark ? 0.15 : 0.8),
                    const Color(0xFFDBEAFE).withValues(alpha: 0),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _burst,
              builder: (context, _) => CustomPaint(
                size: const Size(300, 280),
                painter: _ConfettiPainter(_burst.value),
              ),
            ),
            ScaleTransition(
              scale: _tileScale,
              child: Container(
                width: 132,
                height: 132,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isDark ? 0.08 : 0.7),
                  borderRadius: BorderRadius.circular(38),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF26324F)
                        : const Color(0xFFE0EAFF),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6AA5F8), Color(0xFF2968ED)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: _blueGlow(0.35),
                  ),
                  child: AnimatedBuilder(
                    animation: _check,
                    builder: (context, _) =>
                        CustomPaint(painter: _CheckPainter(_check.value)),
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

class _CheckPainter extends CustomPainter {
  const _CheckPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.3, size.height * 0.52)
      ..lineTo(size.width * 0.45, size.height * 0.66)
      ..lineTo(size.width * 0.72, size.height * 0.36);
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.progress != progress;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t);

  final double t;

  // (angle in degrees, distance, shape: 0 dot, 1 bar, 2 square, size)
  static const _pieces = [
    (-120.0, 128.0, 0, 9.0),
    (-150.0, 120.0, 1, 12.0),
    (-78.0, 118.0, 2, 8.0),
    (-45.0, 132.0, 0, 11.0),
    (-62.0, 102.0, 0, 5.0),
    (-20.0, 120.0, 1, 10.0),
    (15.0, 124.0, 0, 9.0),
    (45.0, 116.0, 2, 9.0),
    (165.0, 128.0, 0, 7.0),
    (140.0, 116.0, 1, 11.0),
    (-172.0, 104.0, 2, 6.0),
    (100.0, 120.0, 0, 6.0),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (t == 0) return;
    final center = size.center(Offset.zero);
    for (final (i, p) in _pieces.indexed) {
      final (deg, dist, shape, s) = p;
      final a = deg * math.pi / 180;
      final pos = center + Offset(math.cos(a), math.sin(a)) * dist * t;
      final paint = Paint()
        ..color = AppColors.confetti[i % AppColors.confetti.length];
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(a + t * 1.5);
      switch (shape) {
        case 0:
          canvas.drawCircle(Offset.zero, s / 2, paint);
        case 1:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: s * 1.6,
                height: s * 0.6,
              ),
              Radius.circular(s),
            ),
            paint,
          );
        default:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: s, height: s),
              Radius.circular(s * 0.25),
            ),
            paint,
          );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
