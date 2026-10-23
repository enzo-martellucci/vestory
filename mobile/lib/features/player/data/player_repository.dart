import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/dio_provider.dart';
import 'package:mobile/features/player/data/models/buy_pack_request.dart';
import 'package:mobile/features/player/data/models/owned_asset.dart';
import 'package:mobile/features/player/data/models/pack_opening_result.dart';
import 'package:mobile/features/player/data/models/pack_type.dart';
import 'package:mobile/features/player/data/models/player_profile.dart';
import 'package:mobile/features/player/data/models/user_pack.dart';

final playerRepositoryProvider = Provider<PlayerRepository>((ref) => PlayerRepository(dio: ref.watch(dioProvider)));

class PlayerRepository {
  final Dio dio;

  PlayerRepository({required this.dio});

  Future<PlayerProfile> getProfile() => _call(() async {
    final response = await dio.get('/api/me/profile');
    return PlayerProfile.fromJson(response.data);
  });

  Future<List<OwnedAsset>> getCollection() => _call(() async {
    final response = await dio.get('/api/me/assets');
    final assets = response.data as List<dynamic>;
    return assets.map((json) => OwnedAsset.fromJson(json as Map<String, dynamic>)).toList();
  });

  Future<UserPack> claimDailyPack() => _call(() async {
    final response = await dio.post('/api/me/packs/daily');
    return UserPack.fromJson(response.data);
  });

  Future<UserPack> buyPack(PackType type) => _call(() async {
    final response = await dio.post('/api/me/packs/buy', data: BuyPackRequest(type: type).toJson());
    return UserPack.fromJson(response.data);
  });

  Future<PackOpeningResult> openPack(String packId) => _call(() async {
    final response = await dio.post('/api/me/packs/$packId/open');
    return PackOpeningResult.fromJson(response.data);
  });

  Future<T> _call<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (exception) {
      throw exception.toApiException();
    }
  }
}
