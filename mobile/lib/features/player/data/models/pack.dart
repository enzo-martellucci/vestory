import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/cards/data/models/asset.dart';
import 'package:mobile/features/cards/data/models/rarity.dart';

part 'pack.g.dart';

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
  final Asset asset;
  final bool newAsset;
  final int gemsEarned;
  final int totalGems;

  const PackOpeningResult({
    required this.packId,
    required this.packType,
    required this.asset,
    required this.newAsset,
    required this.gemsEarned,
    required this.totalGems,
  });

  factory PackOpeningResult.fromJson(Map<String, dynamic> json) => _$PackOpeningResultFromJson(json);
}
