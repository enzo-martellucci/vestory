import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/cards/data/models/card_rarity.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum PackType {
  standard(150, {
    CardRarity.common: 0.60,
    CardRarity.rare: 0.27,
    CardRarity.epic: 0.10,
    CardRarity.legendary: 0.03,
  }),
  premium(400, {
    CardRarity.rare: 0.65,
    CardRarity.epic: 0.28,
    CardRarity.legendary: 0.07,
  }),
  elite(1000, {
    CardRarity.epic: 0.75,
    CardRarity.legendary: 0.25,
  });

  final int price;
  final Map<CardRarity, double> odds;

  const PackType(this.price, this.odds);

  String get label => '${name[0].toUpperCase()}${name.substring(1)}';

  double oddsOf(CardRarity rarity) => odds[rarity] ?? 0;
}
