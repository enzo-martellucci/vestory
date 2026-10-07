import '../../../core/api/api_client.dart';
import '../models/financial_quote.dart';
import '../models/financial_history.dart';

class MarketRepository {
  final ApiClient apiClient;

  MarketRepository({
    required this.apiClient,
  });

  Future<FinancialQuote> getQuote(
      String financialAssetId,
      ) {
    return apiClient.getQuote(
      financialAssetId,
    );
  }

  Future<FinancialHistory> getHistory(
      String financialAssetId,
      ) {
    return apiClient.getHistory(
      financialAssetId,
    );
  }
}