import 'package:material_ui/material_ui.dart';

import 'package:flutter/material.dart';

abstract final class AppColors {
  static const indigo = Color(0xFF263BAA);
  static const vanilla = Color(0xFFFFF4D6);
  static const ink = Color(0xFF151A3B);
  static const muted = Color(0xFF4E5577);
  static const fieldBorder = Color(0xFFE6D6A8);
  static const cardBorder = Color(0xFFF0E3BC);
  static const error = Color(0xFFB4410C);
  static const rare = Color(0xFF3A7FD0);
  static const rareTint = Color(0xFFE1EDFB);
  static const legendary = Color(0xFFE0A21B);
  static const legendaryTint = Color(0xFFFBE7B0);


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
  static const epic = Color(0xFF8B5CF6);
  static const common = Color(0xFF69C6A4);

  static Color trend(bool positive) =>
      positive ? AppColors.positive : AppColors.negative;
}
