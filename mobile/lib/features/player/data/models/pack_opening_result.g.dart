// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pack_opening_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackOpeningResult _$PackOpeningResultFromJson(Map<String, dynamic> json) =>
    PackOpeningResult(
      packId: json['packId'] as String,
      packType: $enumDecode(_$PackTypeEnumMap, json['packType']),
      asset: Asset.fromJson(json['asset'] as Map<String, dynamic>),
      newAsset: json['newAsset'] as bool,
      gemsEarned: (json['gemsEarned'] as num).toInt(),
      totalGems: (json['totalGems'] as num).toInt(),
    );

const _$PackTypeEnumMap = {
  PackType.standard: 'STANDARD',
  PackType.premium: 'PREMIUM',
  PackType.elite: 'ELITE',
};
