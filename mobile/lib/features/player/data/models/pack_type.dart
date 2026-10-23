import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/cards/data/models/rarity.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum PackType {
  standard(200, {
    Rarity.common: 0.70,
    Rarity.rare: 0.22,
    Rarity.epic: 0.07,
    Rarity.legendary: 0.01,
  }),
  premium(1500, {
    Rarity.common: 0.40,
    Rarity.rare: 0.40,
    Rarity.epic: 0.16,
    Rarity.legendary: 0.04,
  }),
  elite(10000, {
    Rarity.rare: 0.50,
    Rarity.epic: 0.40,
    Rarity.legendary: 0.10,
  });

  final int price;
  final Map<Rarity, double> odds;

  const PackType(this.price, this.odds);

  String get label => '${name[0].toUpperCase()}${name.substring(1)}';

  double oddsOf(Rarity rarity) => odds[rarity] ?? 0;
}
