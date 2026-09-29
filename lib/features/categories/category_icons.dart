import 'package:flutter/material.dart';

/// Icons available to categories, keyed by the value stored in the database.
///
/// Stored as keys (not code points) so icon tree-shaking keeps working.
const categoryIcons = <String, IconData>{
  'meetings': Icons.groups_rounded,
  'birthdays': Icons.cake_rounded,
  'anniversaries': Icons.favorite_rounded,
  'appointments': Icons.event_available_rounded,
  'personal': Icons.person_rounded,
  'work': Icons.work_rounded,
  'family': Icons.family_restroom_rounded,
  'holidays': Icons.beach_access_rounded,
  'travel': Icons.flight_takeoff_rounded,
  'health': Icons.favorite_border_rounded,
  'star': Icons.star_rounded,
  'school': Icons.school_rounded,
  'sports': Icons.sports_soccer_rounded,
  'fitness': Icons.fitness_center_rounded,
  'music': Icons.music_note_rounded,
  'food': Icons.restaurant_rounded,
  'shopping': Icons.shopping_bag_rounded,
  'home': Icons.home_rounded,
  'pets': Icons.pets_rounded,
  'finance': Icons.account_balance_wallet_rounded,
  'celebration': Icons.celebration_rounded,
  'book': Icons.menu_book_rounded,
};

const _fallbackIcon = Icons.label_rounded;

IconData categoryIcon(String key) => categoryIcons[key] ?? _fallbackIcon;

/// Swatches offered when creating a custom category.
const customCategoryColors = <int>[
  0xFF4361EE,
  0xFF8B5CF6,
  0xFFEC4899,
  0xFFE11D48,
  0xFFF97316,
  0xFFF59E0B,
  0xFF10B981,
  0xFF22C55E,
  0xFF06B6D4,
  0xFF0EA5E9,
  0xFF334155,
  0xFF78716C,
];
