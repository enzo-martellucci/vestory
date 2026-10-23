import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/cards/data/models/rarity.dart';

extension RarityEffects on Rarity {
  bool get isLegendary => this == Rarity.legendary;

  Duration get chargeDuration => switch (this) {
    Rarity.common || Rarity.rare => Duration.zero,
    Rarity.epic => const Duration(milliseconds: 400),
    Rarity.legendary => const Duration(seconds: 1),
  };

  int get particleCount => switch (this) {
    Rarity.common => 12,
    Rarity.rare => 24,
    Rarity.epic => 40,
    Rarity.legendary => 80,
  };

  Duration get revealDuration => switch (this) {
    Rarity.common || Rarity.rare => const Duration(milliseconds: 1200),
    Rarity.epic => const Duration(milliseconds: 1400),
    Rarity.legendary => const Duration(seconds: 2),
  };

  Duration get walkoutStepDuration => switch (this) {
    Rarity.common => const Duration(milliseconds: 1000),
    Rarity.rare => const Duration(milliseconds: 1100),
    Rarity.epic => const Duration(milliseconds: 1250),
    Rarity.legendary => const Duration(milliseconds: 1500),
  };

  List<Color> get backgroundColors => switch (this) {
    Rarity.legendary => const [Color(0xFF1A1405), Colors.black],
    _ => [Color.lerp(color, Colors.black, 0.55)!, const Color(0xFF0B0D1F)],
  };

  double get glowStrength => switch (this) {
    Rarity.common => 0,
    Rarity.rare => 0.5,
    Rarity.epic => 0.75,
    Rarity.legendary => 1,
  };

  Future<void> haptic() => switch (this) {
    Rarity.common => Future.value(),
    Rarity.rare => HapticFeedback.lightImpact(),
    Rarity.epic => HapticFeedback.mediumImpact(),
    Rarity.legendary => HapticFeedback.heavyImpact(),
  };
}
