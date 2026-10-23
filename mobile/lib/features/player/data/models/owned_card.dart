import 'package:json_annotation/json_annotation.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';

part 'owned_card.g.dart';

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
