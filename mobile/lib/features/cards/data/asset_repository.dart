import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/dio_provider.dart';
import 'package:mobile/features/cards/data/models/asset.dart';

final assetRepositoryProvider = Provider<AssetRepository>((ref) => AssetRepository(dio: ref.watch(dioProvider)));

class AssetRepository {
  final Dio dio;

  AssetRepository({required this.dio});

  Future<List<Asset>> getAssets() async {
    try {
      final response = await dio.get('/api/assets');
      final assets = response.data as List<dynamic>;
      return assets.map((json) => Asset.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (exception) {
      throw exception.toApiException();
    }
  }
}
