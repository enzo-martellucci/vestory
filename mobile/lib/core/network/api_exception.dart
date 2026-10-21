import 'package:dio/dio.dart';
import 'package:mobile/core/network/api_error.dart';

sealed class ApiException implements Exception {}

class NetworkException extends ApiException {}

class ResponseException extends ApiException {
  final ApiError error;

  ResponseException(this.error);
}

extension DioExceptionMapper on DioException {
  ApiException toApiException() => switch (type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => NetworkException(),
    DioExceptionType.badResponse => ResponseException(_toApiError()),
    _ => throw this,
  };

  ApiError _toApiError() {
    final data = response?.data;
    if (data is Map<String, dynamic>)
      return ApiError.fromJson(data);
    return ApiError(status: response?.statusCode ?? 0);
  }
}
