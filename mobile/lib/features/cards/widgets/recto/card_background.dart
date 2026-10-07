import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CardBackground extends StatelessWidget {
  final String? imageUrl;
  final Color rarityColor;

  const CardBackground({
    super.key,
    required this.imageUrl,
    required this.rarityColor,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return _fallback();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _fallback(),
        ),
        // Harmonise les images trop fortes.
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.06),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _fallback() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.cardFallbackSurface,
            rarityColor.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.show_chart_rounded,
          size: 44,
          color: rarityColor.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}
