import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/cards/data/models/asset.dart';

part 'owned_asset.g.dart';

@JsonSerializable(createToJson: false)
class OwnedAsset {
  final Asset asset;
  final bool favorite;
  final DateTime firstObtainedAt;
  final DateTime lastObtainedAt;

  const OwnedAsset({
    required this.asset,
    required this.favorite,
    required this.firstObtainedAt,
    required this.lastObtainedAt,
  });

  factory OwnedAsset.fromJson(Map<String, dynamic> json) => _$OwnedAssetFromJson(json);
}
