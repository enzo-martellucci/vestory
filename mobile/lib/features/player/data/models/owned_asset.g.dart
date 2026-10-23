// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owned_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnedAsset _$OwnedAssetFromJson(Map<String, dynamic> json) => OwnedAsset(
  asset: Asset.fromJson(json['asset'] as Map<String, dynamic>),
  favorite: json['favorite'] as bool,
  firstObtainedAt: DateTime.parse(json['firstObtainedAt'] as String),
  lastObtainedAt: DateTime.parse(json['lastObtainedAt'] as String),
);
