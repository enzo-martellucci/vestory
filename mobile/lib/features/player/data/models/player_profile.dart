import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
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
class OwnedCard {
  final AssetCardModel card;
  final bool favorite;
  final DateTime firstObtainedAt;
  final DateTime lastObtainedAt;

  const OwnedCard({
    required this.card,
    required this.favorite,
    required this.firstObtainedAt,
    required this.lastObtainedAt,
  });

  factory OwnedCard.fromJson(Map<String, dynamic> json) => _$OwnedCardFromJson(json);
}
