import 'package:flutter/material.dart';

import '../category_icons.dart';

/// Rounded tinted square showing a category's icon in its color.
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({
    super.key,
    required this.iconKey,
    required this.color,
    this.size = 44,
  });

  final String iconKey;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.22 : 0.12),
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Icon(categoryIcon(iconKey), color: color, size: size * 0.5),
    );
  }
}
