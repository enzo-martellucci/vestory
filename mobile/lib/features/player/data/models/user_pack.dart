import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/player/data/models/pack_source.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';

part 'user_pack.g.dart';

@JsonSerializable(createToJson: false)
class UserPack {
  final String id;
  final PackType type;
  final PackSource source;
  final DateTime obtainedAt;

  const UserPack({required this.id, required this.type, required this.source, required this.obtainedAt});

  factory UserPack.fromJson(Map<String, dynamic> json) => _$UserPackFromJson(json);
}
