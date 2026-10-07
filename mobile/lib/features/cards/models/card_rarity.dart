import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum CardRarity {
  common('COMMON', 'C', AppColors.common),
  rare('RARE', 'R', AppColors.rare),
  epic('EPIC', 'E', AppColors.epic),
  legendary('LEGENDARY', 'L', AppColors.legendary);

  final String apiValue;
  final String letter;
  final Color color;

  const CardRarity(this.apiValue, this.letter, this.color);

  static CardRarity fromApi(String? value) {
    for (final rarity in values) {
      if (rarity.apiValue == value) return rarity;
    }
    return CardRarity.common;
  }
}
