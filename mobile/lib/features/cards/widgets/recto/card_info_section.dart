import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/asset_card_model.dart';
import 'card_footer.dart';

class CardInfoSection extends StatelessWidget {
  final AssetCardModel card;
  final int totalCards;

  const CardInfoSection({
    super.key,
    required this.card,
    required this.totalCards,
  });

  String get _description {
    final value = card.description?.trim();
    return (value == null || value.isEmpty)
        ? 'No description available.'
        : value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            card.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              height: 1.15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                _description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 7,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 8, bottom: 2),
            color: AppColors.divider,
          ),
          CardFooter(
            assetType: card.assetType,
            collectionNumber: card.collectionNumber,
            totalCards: totalCards,
          ),
        ],
      ),
    );
  }
}
