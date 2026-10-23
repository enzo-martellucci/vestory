// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_pack.dart';

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
