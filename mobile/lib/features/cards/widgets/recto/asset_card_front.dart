import 'package:flutter/material.dart';

import '../../models/asset_card_model.dart';
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

  Color get rarityColor {
    switch (card.rarity) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: rarityColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          const BoxShadow(
            color: Color(0x25000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: rarityColor.withValues(
              alpha: 0.30,
            ),
            blurRadius: 22,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          color: const Color(0xFFF8F8F6),
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CardBackground(
                      imageUrl: card.logoUrl,
                      rarityColor: rarityColor,
                    ),

                    Positioned(
                      top: 12,
                      left: 12,
                      child: RarityBadge(
                        rarity: card.rarity,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 9,
                child: CardInfoSection(
                  card: card,
                  totalCards: totalCards,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}