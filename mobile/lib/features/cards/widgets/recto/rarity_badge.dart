import 'package:flutter/material.dart';

class RarityBadge extends StatelessWidget {
  final String rarity;

  const RarityBadge({
    super.key,
    required this.rarity,
  });

  Color get color {
    switch (rarity) {
      case 'LEGENDARY':
        return const Color(0xFFD8A73D);

      case 'EPIC':
        return const Color(0xFF8B5CF6);

      case 'RARE':
        return const Color(0xFF4C7DFF);

      default:
        return const Color(0xFF69C6A4);
    }
  }

  String get letter {
    switch (rarity) {
      case 'LEGENDARY':
        return 'L';

      case 'EPIC':
        return 'E';

      case 'RARE':
        return 'R';

      default:
        return 'C';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.88,
        ),

        borderRadius: BorderRadius.circular(9),

        border: Border.all(
          color: color,
          width: 1.3,
        ),

        boxShadow: [
          BoxShadow(
            color: color.withValues(
              alpha: 0.30,
            ),
            blurRadius: 8,
          ),
        ],
      ),

      child: Text(
        letter,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}