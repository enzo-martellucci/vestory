import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/cards/data/models/asset.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';

part 'pack_opening_result.g.dart';

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
