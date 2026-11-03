import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/cards/data/models/asset.dart';
import 'package:mobile/features/player/data/models/pack.dart';

part 'player_profile.g.dart';

@JsonSerializable(createToJson: false)
class PlayerProfile {
  final int gems;
  final List<UserPack> unopenedPacks;
  final bool dailyPackAvailable;
  final DateTime? nextDailyPackAt;

  const PlayerProfile({
    required this.gems,
    required this.unopenedPacks,
    required this.dailyPackAvailable,
    this.nextDailyPackAt,
  });

  factory PlayerProfile.fromJson(Map<String, dynamic> json) => _$PlayerProfileFromJson(json);
}

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
