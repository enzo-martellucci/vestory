import 'package:dio/dio.dart';

import '../../features/cards/models/asset_card_model.dart';
import '../../features/market/models/financial_quote.dart';
import '../../features/market/models/financial_history.dart';

class ApiClient {
  static const String baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8080',);

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<AssetCardModel>> getCards() async {
    final response = await _dio.get('/api/cards');

    final data = response.data as List<dynamic>;

    return data.map((json) => AssetCardModel.fromJson(json as Map<String, dynamic>,),).toList();
  }

  Future<FinancialQuote> getQuote(String financialAssetId,) async {
    final response = await _dio.get('/api/market/assets/''$financialAssetId/quote',);
    return FinancialQuote.fromJson(response.data as Map<String, dynamic>,);
  }

  Future<FinancialHistory> getHistory(
      String financialAssetId,
      ) async {
    final response = await _dio.get(
      '/api/market/assets/'
          '$financialAssetId/history',
    );

    return FinancialHistory.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}