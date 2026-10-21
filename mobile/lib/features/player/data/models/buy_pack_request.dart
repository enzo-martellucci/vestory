import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';

part 'buy_pack_request.g.dart';

@JsonSerializable(createFactory: false)
class BuyPackRequest {
  final PackType type;

  const BuyPackRequest({required this.type});

  Map<String, dynamic> toJson() => _$BuyPackRequestToJson(this);
}
