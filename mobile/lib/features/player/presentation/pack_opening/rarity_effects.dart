import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/cards/data/models/card_rarity.dart';

extension RarityEffects on CardRarity {
  bool get isLegendary => this == CardRarity.legendary;

  Duration get chargeDuration => switch (this) {
    CardRarity.common || CardRarity.rare => Duration.zero,
    CardRarity.epic => const Duration(milliseconds: 400),
    CardRarity.legendary => const Duration(seconds: 1),
  };

  int get particleCount => switch (this) {
    CardRarity.common => 12,
    CardRarity.rare => 24,
    CardRarity.epic => 40,
    CardRarity.legendary => 80,
  };

  Duration get revealDuration => switch (this) {
    CardRarity.common || CardRarity.rare => const Duration(milliseconds: 1200),
    CardRarity.epic => const Duration(milliseconds: 1400),
    CardRarity.legendary => const Duration(seconds: 2),
  };

  Duration get walkoutStepDuration => switch (this) {
    CardRarity.common => const Duration(milliseconds: 1000),
    CardRarity.rare => const Duration(milliseconds: 1100),
    CardRarity.epic => const Duration(milliseconds: 1250),
    CardRarity.legendary => const Duration(milliseconds: 1500),
  };

  List<Color> get backgroundColors => switch (this) {
    CardRarity.legendary => const [Color(0xFF1A1405), Colors.black],
    _ => [Color.lerp(color, Colors.black, 0.55)!, const Color(0xFF0B0D1F)],
  };

  double get glowStrength => switch (this) {
    CardRarity.common => 0,
    CardRarity.rare => 0.5,
    CardRarity.epic => 0.75,
    CardRarity.legendary => 1,
  };

  Future<void> haptic() => switch (this) {
    CardRarity.common => Future.value(),
    CardRarity.rare => HapticFeedback.lightImpact(),
    CardRarity.epic => HapticFeedback.mediumImpact(),
    CardRarity.legendary => HapticFeedback.heavyImpact(),
  };
}
