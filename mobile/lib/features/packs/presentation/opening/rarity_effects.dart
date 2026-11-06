import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/features/assets/domain/rarity.dart';
import 'package:mobile/features/assets/presentation/asset_style.dart';

extension RarityEffects on Rarity {
  Duration get chargeDuration => switch (this) {
    Rarity.common || Rarity.rare => Duration.zero,
    Rarity.epic => const Duration(milliseconds: 800),
    Rarity.legendary => const Duration(milliseconds: 1800),
  };

  Duration get walkoutStepDuration => switch (this) {
    Rarity.common => const Duration(milliseconds: 1000),
    Rarity.rare => const Duration(milliseconds: 1100),
    Rarity.epic => const Duration(milliseconds: 1250),
    Rarity.legendary => const Duration(milliseconds: 1500),
  };

  Duration get revealDuration => switch (this) {
    Rarity.common || Rarity.rare => const Duration(milliseconds: 1800),
    Rarity.epic => const Duration(milliseconds: 2100),
    Rarity.legendary => const Duration(seconds: 3),
  };

  int get particleCount => switch (this) {
    Rarity.common => 12,
    Rarity.rare => 24,
    Rarity.epic => 40,
    Rarity.legendary => 80,
  };

  double get glowStrength => switch (this) {
    Rarity.common => 0,
    Rarity.rare => 0.5,
    Rarity.epic => 0.75,
    Rarity.legendary => 1,
  };

  List<Color> get backgroundColors => switch (this) {
    Rarity.legendary => const [Color(0xFF1A1405), Colors.black],
    _ => [Color.lerp(color, Colors.black, 0.55)!, const Color(0xFF0B0D1F)],
  };

  Future<void> haptic() => switch (this) {
    Rarity.common => Future.value(),
    Rarity.rare => HapticFeedback.lightImpact(),
    Rarity.epic => HapticFeedback.mediumImpact(),
    Rarity.legendary => HapticFeedback.heavyImpact(),
  };
}
