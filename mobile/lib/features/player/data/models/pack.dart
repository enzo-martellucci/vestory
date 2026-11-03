import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
import 'package:mobile/features/cards/data/models/card_rarity.dart';

part 'pack.g.dart';

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

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum PackSource { welcome, daily, shop, quiz }

@JsonSerializable(createToJson: false)
class UserPack {
  final String id;
  final PackType type;
  final PackSource source;
  final DateTime obtainedAt;

  const UserPack({required this.id, required this.type, required this.source, required this.obtainedAt});

  factory UserPack.fromJson(Map<String, dynamic> json) => _$UserPackFromJson(json);
}

@JsonSerializable(createToJson: false)
class PackOpeningResult {
  final String packId;
  final PackType packType;
  final AssetCardModel card;
  final bool newCard;
  final int gemsEarned;
  final int totalGems;

  const PackOpeningResult({
    required this.packId,
    required this.packType,
    required this.card,
    required this.newCard,
    required this.gemsEarned,
    required this.totalGems,
  });

  factory PackOpeningResult.fromJson(Map<String, dynamic> json) => _$PackOpeningResultFromJson(json);
}
