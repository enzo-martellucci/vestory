import 'package:mobile/features/assets/domain/rarity.dart';

enum PackType {
  standard('Standard', 200, {Rarity.common: 0.70, Rarity.rare: 0.22, Rarity.epic: 0.07, Rarity.legendary: 0.01}),
  premium('Premium', 1500, {Rarity.common: 0.40, Rarity.rare: 0.40, Rarity.epic: 0.16, Rarity.legendary: 0.04}),
  elite('Elite', 10000, {Rarity.rare: 0.50, Rarity.epic: 0.40, Rarity.legendary: 0.10});

  final String label;
  final int price;
  final Map<Rarity, double> odds;

  const PackType(this.label, this.price, this.odds);

  double oddsOf(Rarity rarity) => odds[rarity] ?? 0;
}
