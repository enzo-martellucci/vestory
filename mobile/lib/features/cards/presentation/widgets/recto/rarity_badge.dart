import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/cards/data/models/rarity.dart';

class RarityBadge extends StatelessWidget {
  final Rarity rarity;

  const RarityBadge({super.key, required this.rarity});

  @override
  Widget build(BuildContext context) {
    final color = rarity.color;

    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color, width: 1.3),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.30), blurRadius: 8),
        ],
      ),
      child: Text(
        rarity.letter,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
