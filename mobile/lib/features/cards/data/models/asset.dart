import 'package:mobile/features/cards/data/models/rarity.dart';

class Asset {
  final int id;
  final String symbol;
  final String name;
  final String type;
  final Rarity rarity;
  final String? country;
  final String? sector;
  final String? logoUrl;
  final String? description;

  const Asset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.type,
    required this.rarity,
    this.country,
    this.sector,
    this.logoUrl,
    this.description,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'] as int,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      rarity: Rarity.fromApi(json['rarity'] as String?),
      country: json['country'] as String?,
      sector: json['sector'] as String?,
      logoUrl: json['logoUrl'] as String?,
      description: json['description'] as String?,
    );
  }
}
