import 'package:flutter/material.dart';

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

  String get description {
    final value = card.description?.trim();

    if (value == null || value.isEmpty) {
      return 'No description available.';
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      color: const Color(0xFFF8F8F6),

      padding: const EdgeInsets.fromLTRB(
        15,
        14,
        15,
        11,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          // TITRE

          Text(
            card.name,

            maxLines: 2,

            overflow:
            TextOverflow.ellipsis,

            style: const TextStyle(
              color: Color(0xFF181818),

              fontSize: 11,

              height: 1.15,

              fontWeight:
              FontWeight.w800,
            ),
          ),

          const SizedBox(height: 8),

          // DESCRIPTION

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF777777),
                  fontSize: 7,
                  height: 1.4,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          // SÉPARATION

          Container(
            height: 1,

            margin: const EdgeInsets.only(
              top: 8,
              bottom: 2,
            ),

            color: const Color(
              0xFFDADAD7,
            ),
          ),

          // FOOTER

          CardFooter(
            assetType:
            card.assetType,

            collectionNumber:
            card.collectionNumber,

            totalCards:
            totalCards,
          ),
        ],
      ),
    );
  }
}