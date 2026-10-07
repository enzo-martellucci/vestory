import 'package:flutter/material.dart';

abstract final class AppColors {
  // Surfaces des cartes
  static const cardSurface = Color(0xFFF8F8F6);
  static const cardFallbackSurface = Color(0xFFF5F5F2);
  static const divider = Color(0xFFDADAD7);
  static const shadow = Color(0x25000000);

  // Texte
  static const textPrimary = Color(0xFF181818);
  static const textBody = Color(0xFF252525);
  static const textStrong = Color(0xFF282828);
  static const textSecondary = Color(0xFF777777);
  static const textMuted = Color(0xFF999999);
  static const iconMuted = Color(0xFFB0B0B0);

  // Marché
  static const positive = Color(0xFF159B61);
  static const negative = Color(0xFFD94B4B);

  // Rareté
  static const legendary = Color(0xFFD8A73D);
  static const epic = Color(0xFF8B5CF6);
  static const rare = Color(0xFF4C7DFF);
  static const common = Color(0xFF69C6A4);

  static Color trend(bool positive) =>
      positive ? AppColors.positive : AppColors.negative;
}
