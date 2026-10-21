import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/dio_provider.dart';
import 'package:mobile/core/storage/token_storage.dart';
import 'package:mobile/features/auth/data/models/auth_response.dart';
import 'package:mobile/features/auth/data/models/login_request.dart';
import 'package:mobile/features/auth/data/models/refresh_token_request.dart';
import 'package:mobile/features/auth/data/models/register_request.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(dio: ref.watch(dioProvider), tokenStorage: ref.watch(tokenStorageProvider)),
);

class AuthRepository {
  final Dio dio;
  final TokenStorage tokenStorage;

  AuthRepository({required this.dio, required this.tokenStorage});

  Future<void> login(LoginRequest request) => _authenticate('/api/auth/login', request.toJson());

  Future<void> register(RegisterRequest request) => _authenticate('/api/auth/register', request.toJson());

  Future<void> logout() async {
    final refreshToken = await tokenStorage.readRefreshToken();
    await tokenStorage.clear();
    if (refreshToken == null)
      return;

    dio.post('/api/auth/logout', data: RefreshTokenRequest(refreshToken: refreshToken).toJson()).ignore();
  }

  Future<void> _authenticate(String path, Map<String, dynamic> body) async {
    try {
      final response = await dio.post(path, data: body);
      final authResponse = AuthResponse.fromJson(response.data);
      await tokenStorage.save(accessToken: authResponse.accessToken, refreshToken: authResponse.refreshToken);
    } on DioException catch (exception) {
      throw exception.toApiException();
    }
  }
}
