import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/cards/presentation/widgets/asset_card.dart';
import 'package:mobile/features/player/data/models/pack_opening_result.dart';

class OpeningSummary extends StatelessWidget {
  final List<PackOpeningResult> results;
  final int totalCards;

  const OpeningSummary({super.key, required this.results, required this.totalCards});

  @override
  Widget build(BuildContext context) {
    final newCards = results.where((result) => result.newCard).length;
    final gemsEarned = results.fold(0, (sum, result) => sum + result.gemsEarned);

    return Column(
      spacing: 8,
      children: [
        const Text('Your pulls', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: .w900)),
        Text(
          '$newCards new ${newCards == 1 ? 'card' : 'cards'} · +$gemsEarned gems',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: AssetCard.aspectRatio,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) => AssetCard(card: results[index].card, totalCards: totalCards),
          ),
        ),
      ],
    );
  }
}
