// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPack _$UserPackFromJson(Map<String, dynamic> json) => UserPack(
  id: json['id'] as String,
  type: $enumDecode(_$PackTypeEnumMap, json['type']),
  source: $enumDecode(_$PackSourceEnumMap, json['source']),
  obtainedAt: DateTime.parse(json['obtainedAt'] as String),
);

const _$PackTypeEnumMap = {
  PackType.standard: 'STANDARD',
  PackType.premium: 'PREMIUM',
  PackType.elite: 'ELITE',
};

const _$PackSourceEnumMap = {
  PackSource.welcome: 'WELCOME',
  PackSource.daily: 'DAILY',
  PackSource.shop: 'SHOP',
  PackSource.quiz: 'QUIZ',
};

PackOpeningResult _$PackOpeningResultFromJson(Map<String, dynamic> json) =>
    PackOpeningResult(
      packId: json['packId'] as String,
      packType: $enumDecode(_$PackTypeEnumMap, json['packType']),
      asset: Asset.fromJson(json['asset'] as Map<String, dynamic>),
      newAsset: json['newAsset'] as bool,
      gemsEarned: (json['gemsEarned'] as num).toInt(),
      totalGems: (json['totalGems'] as num).toInt(),
    );
