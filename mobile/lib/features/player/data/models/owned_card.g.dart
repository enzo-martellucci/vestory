// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owned_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnedCard _$OwnedCardFromJson(Map<String, dynamic> json) => OwnedCard(
  card: AssetCardModel.fromJson(json['card'] as Map<String, dynamic>),
  favorite: json['favorite'] as bool,
  firstObtainedAt: DateTime.parse(json['firstObtainedAt'] as String),
  lastObtainedAt: DateTime.parse(json['lastObtainedAt'] as String),
);
