import 'package:flutter/material.dart';

/// Planly palette, sampled from the Stitch design references in docs/design/.
abstract final class AppColors {
  static const primary = Color(0xFF2563EB);
  static const primarySoft = Color(0xFFEFF6FF); // icon badge backgrounds
  static const primaryContainer = Color(0xFFE5EEFF); // sync bar, chips
  static const navIndicator = Color(0xFFD3E4FE);
  static const secondary = Color(0xFF8B5CF6);
  static const secondarySoft = Color(0xFFEDE5FE);

  // Light
  static const background = Color(0xFFF8FAFF);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFF1F5F9);
  static const text = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);
  static const textSubtle = Color(0xFF94A3B8);
  static const outline = Color(0xFFE2E8F0);
  static const outlineSoft = Color(0xFFF1F5F9);

  // Dark (deep navy)
  static const backgroundDark = Color(0xFF0B1224);
  static const surfaceDark = Color(0xFF141D33);
  static const surfaceMutedDark = Color(0xFF1C2742);
  static const textDark = Color(0xFFE8ECF7);
  static const textMutedDark = Color(0xFF9AA5BF);
  static const outlineDark = Color(0xFF26324F);
  static const primaryDark = Color(0xFF5B8DEF);

  static const success = Color(0xFF10B981);
  static const successSoft = Color(0xFFECFDF5);
  static const successDeep = Color(0xFF006947);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const errorSoft = Color(0xFFFEE2E2);

  /// App-icon gradient: blue into teal (splash logo, header badge).
  static const logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5592F3), Color(0xFF337CF3), Color(0xFF10C5C4)],
    stops: [0, 0.55, 1],
  );

  /// Glossy blue used on hero tiles (setup complete, date badges).
  static const tileGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF619AF7), Color(0xFF2968ED)],
  );

  /// Accent colors used in illustrations, logo dots and confetti.
  static const confetti = [
    Color(0xFFFB923C),
    Color(0xFF48D7A3),
    Color(0xFFFBC945),
    Color(0xFFB8A1FB),
    Color(0xFF38BDF8),
    Color(0xFFF472B6),
    Color(0xFF5A9FF9),
  ];

  /// Google brand colors (for the "G" mark only).
  static const googleBlue = Color(0xFF4285F4);
  static const googleRed = Color(0xFFEA4335);
  static const googleYellow = Color(0xFFFBBC05);
  static const googleGreen = Color(0xFF34A853);
}

/// Soft, blue-tinted elevation used by cards and primary buttons.
abstract final class AppShadows {
  static List<BoxShadow> card(Brightness b) => b == Brightness.dark
      ? const []
      : const [
          BoxShadow(
            color: Color(0x0F1E3A8A),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ];

  static const button = [
    BoxShadow(color: Color(0x332563EB), blurRadius: 20, offset: Offset(0, 8)),
  ];
}
