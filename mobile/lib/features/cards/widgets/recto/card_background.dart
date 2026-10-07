import 'package:flutter/material.dart';

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
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _fallback();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl!,
          fit: BoxFit.cover,

          errorBuilder: (context, error, stackTrace,) {
            return _fallback();
          },
        ),

        // Harmonise les images trop fortes.
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(
                  alpha: 0.05,
                ),

                Colors.transparent,

                Colors.black.withValues(
                  alpha: 0.06,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _fallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            const Color(0xFFF5F5F2),

            rarityColor.withValues(
              alpha: 0.12,
            ),
          ],
        ),
      ),

      child: Center(
        child: Icon(
          Icons.show_chart_rounded,
          size: 44,
          color: rarityColor.withValues(
            alpha: 0.55,
          ),
        ),
      ),
    );
  }
}