import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
import 'package:mobile/features/cards/presentation/widgets/card_frame.dart';
import 'package:mobile/features/cards/presentation/widgets/recto/card_background.dart';
import 'package:mobile/features/cards/presentation/widgets/recto/card_info_section.dart';
import 'package:mobile/features/cards/presentation/widgets/recto/rarity_badge.dart';

class AssetCardFront extends StatelessWidget {
  final AssetCardModel card;
  final int totalCards;

  const AssetCardFront({
    super.key,
    required this.card,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    return CardFrame(
      rarity: card.rarity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CardBackground(
                  imageUrl: card.logoUrl,
                  rarityColor: card.rarity.color,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: RarityBadge(rarity: card.rarity),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: CardInfoSection(card: card, totalCards: totalCards),
          ),
        ],
      ),
    );
  }
}
