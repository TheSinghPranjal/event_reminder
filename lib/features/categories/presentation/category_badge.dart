import 'package:flutter/material.dart';

import '../../../core/widgets/soft_card.dart';
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
  Widget build(BuildContext context) =>
      IconBadge(icon: categoryIcon(iconKey), color: color, size: size);
}
