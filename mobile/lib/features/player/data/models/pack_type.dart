import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/cards/data/models/card_rarity.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum PackType {
  standard(200, {
    CardRarity.common: 0.70,
    CardRarity.rare: 0.22,
    CardRarity.epic: 0.07,
    CardRarity.legendary: 0.01,
  }),
  premium(1500, {
    CardRarity.common: 0.40,
    CardRarity.rare: 0.40,
    CardRarity.epic: 0.16,
    CardRarity.legendary: 0.04,
  }),
  elite(10000, {
    CardRarity.rare: 0.50,
    CardRarity.epic: 0.40,
    CardRarity.legendary: 0.10,
  });

  final int price;
  final Map<CardRarity, double> odds;

  const PackType(this.price, this.odds);

  String get label => '${name[0].toUpperCase()}${name.substring(1)}';

  double oddsOf(CardRarity rarity) => odds[rarity] ?? 0;
}
