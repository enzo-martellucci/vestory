import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

enum Rarity {
  common('COMMON', 'C', AppColors.common),
  rare('RARE', 'R', AppColors.rare),
  epic('EPIC', 'E', AppColors.epic),
  legendary('LEGENDARY', 'L', AppColors.legendary);

  final String apiValue;
  final String letter;
  final Color color;

  const Rarity(this.apiValue, this.letter, this.color);

  static Rarity fromApi(String? value) {
    for (final rarity in values) {
      if (rarity.apiValue == value) return rarity;
    }
    return Rarity.common;
  }
}
