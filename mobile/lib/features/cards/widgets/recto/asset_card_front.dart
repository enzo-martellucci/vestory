import 'package:flutter/material.dart';

import '../../models/asset_card_model.dart';
import '../card_frame.dart';
import 'card_background.dart';
import 'card_info_section.dart';
import 'rarity_badge.dart';

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
