import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/player/data/models/user_pack.dart';

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
