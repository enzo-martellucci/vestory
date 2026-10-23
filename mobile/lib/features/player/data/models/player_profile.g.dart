// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerProfile _$PlayerProfileFromJson(Map<String, dynamic> json) =>
    PlayerProfile(
      gems: (json['gems'] as num).toInt(),
      unopenedPacks: (json['unopenedPacks'] as List<dynamic>)
          .map((e) => UserPack.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyPackAvailable: json['dailyPackAvailable'] as bool,
      nextDailyPackAt: json['nextDailyPackAt'] == null
          ? null
          : DateTime.parse(json['nextDailyPackAt'] as String),
    );
