import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/auth_interceptor.dart';
import 'package:mobile/core/storage/token_storage.dart';

const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8080');

final onSessionExpiredProvider = Provider<void Function()>((ref) => throw UnimplementedError());

final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    contentType: Headers.jsonContentType,
  );

  final authInterceptor = AuthInterceptor(
    plainDio: Dio(options),
    tokenStorage: ref.watch(tokenStorageProvider),
    onSessionExpired: ref.watch(onSessionExpiredProvider),
  );

  return Dio(options)..interceptors.add(authInterceptor);
});
