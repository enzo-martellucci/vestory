import '../../../core/api/api_client.dart';
import '../models/asset_card_model.dart';

class CardRepository {
  final ApiClient apiClient;

  CardRepository({
    required this.apiClient,
  });

  Future<List<AssetCardModel>> getCards() {
    return apiClient.getCards();
  }
}