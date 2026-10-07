import '../../../core/api/api_client.dart';
import '../models/asset_card_model.dart';

abstract interface class CardRepository {
  Future<List<AssetCardModel>> getCards();
}

class ApiCardRepository implements CardRepository {
  final ApiClient _api;

  const ApiCardRepository(this._api);

  @override
  Future<List<AssetCardModel>> getCards() async {
    final data = await _api.getJsonList('/api/cards');
    return data
        .map((json) => AssetCardModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
