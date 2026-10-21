import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/dio_provider.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';

final cardRepositoryProvider = Provider<CardRepository>((ref) => CardRepository(dio: ref.watch(dioProvider)));

class CardRepository {
  final Dio dio;

  CardRepository({required this.dio});

  Future<List<AssetCardModel>> getCards() async {
    try {
      final response = await dio.get('/api/cards');
      final cards = response.data as List<dynamic>;
      return cards.map((json) => AssetCardModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (exception) {
      throw exception.toApiException();
    }
  }
}
