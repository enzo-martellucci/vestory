import 'card_rarity.dart';

class AssetCardModel {
  final String id;
  final int collectionNumber;
  final CardRarity rarity;
  final double rarityScore;
  final bool enabled;

  final String financialAssetId;
  final String symbol;
  final String name;
  final String assetType;
  final String? logoUrl;
  final String? description;

  const AssetCardModel({
    required this.id,
    required this.collectionNumber,
    required this.rarity,
    required this.rarityScore,
    required this.enabled,
    required this.financialAssetId,
    required this.symbol,
    required this.name,
    required this.assetType,
    this.logoUrl,
    this.description,
  });

  factory AssetCardModel.fromJson(Map<String, dynamic> json) {
    return AssetCardModel(
      id: json['id'] as String,
      collectionNumber: (json['collectionNumber'] as num).toInt(),
      rarity: CardRarity.fromApi(json['rarity'] as String?),
      rarityScore: (json['rarityScore'] as num).toDouble(),
      enabled: json['enabled'] as bool,
      financialAssetId: json['financialAssetId'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      assetType: json['assetType'] as String,
      logoUrl: json['logoUrl'] as String?,
      description: json['description'] as String?,
    );
  }
}
