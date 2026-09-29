import 'package:flutter/material.dart';

/// Brand palette from the Planly design system.
abstract final class AppColors {
  static const primary = Color(0xFF4361EE);
  static const secondary = Color(0xFF8B5CF6);

  // Light
  static const background = Color(0xFFF8FAFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFEEF2FC);
  static const text = Color(0xFF172033);
  static const textMuted = Color(0xFF64708A);
  static const outline = Color(0xFFE2E7F3);

  // Dark (deep navy)
  static const backgroundDark = Color(0xFF0B1224);
  static const surfaceDark = Color(0xFF141D33);
  static const surfaceMutedDark = Color(0xFF1C2742);
  static const textDark = Color(0xFFE8ECF7);
  static const textMutedDark = Color(0xFF9AA5BF);
  static const outlineDark = Color(0xFF26324F);
  static const primaryDark = Color(0xFF6A84FF);

  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);

  /// Blue-to-purple brand gradient (logo, hero accents).
  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
}
