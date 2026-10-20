import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exception.dart';

/// Client HTTP générique.
class ApiClient {
  static String get defaultBaseUrl {
    const fromEnvironment = String.fromEnvironment('API_BASE_URL');
    if (fromEnvironment.isNotEmpty) return fromEnvironment;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080';
    }
    return 'http://127.0.0.1:8080';
  }

  final Dio _dio;

  ApiClient({String? baseUrl, Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? defaultBaseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  /// GET qui renvoie un objet JSON.
  Future<Map<String, dynamic>> getJson(String path) async {
    final data = await _get(path);
    if (data is! Map<String, dynamic>) {
      throw const ApiException('Invalid response format (object expected).');
    }
    return data;
  }

  /// GET qui renvoie une liste JSON.
  Future<List<dynamic>> getJsonList(String path) async {
    final data = await _get(path);
    if (data is! List<dynamic>) {
      throw const ApiException('Invalid response format (list expected).');
    }
    return data;
  }

  Future<dynamic> _get(String path) async {
    try {
      final response = await _dio.get<dynamic>(path);
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
