import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CardFooter extends StatelessWidget {
  final String assetType;
  final int collectionNumber;
  final int totalCards;

  const CardFooter({
    super.key,
    required this.assetType,
    required this.collectionNumber,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          assetType,
          style: const TextStyle(
            color: AppColors.textBody,
            fontSize: 6,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          '$collectionNumber/$totalCards',
          style: const TextStyle(
            color: AppColors.textBody,
            fontSize: 6,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
