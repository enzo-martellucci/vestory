import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/card_rarity.dart';

// widget de la carte avec un contour en fonction de la rareté
class CardFrame extends StatelessWidget {
  final CardRarity rarity;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const CardFrame({
    super.key,
    required this.rarity,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final color = rarity.color;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          const BoxShadow(
            color: AppColors.shadow,
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: color.withValues(alpha: 0.30),
            blurRadius: 22,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          color: AppColors.cardSurface,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
