import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          'The server at ${e.requestOptions.baseUrl} took too long to respond.',
        );
      case DioExceptionType.connectionError:
        return ApiException(
          'Unable to reach the server at ${e.requestOptions.baseUrl} (${e.error ?? e.message}).',
        );
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final body = e.response?.data;
        final detail = body is Map<String, dynamic> ? body['detail'] as String? : null;
        if (code == 404) {
          return ApiException(detail ?? 'Resource not found.', statusCode: code);
        }
        return ApiException(detail ?? 'Server error ($code).', statusCode: code);
      case DioExceptionType.cancel:
        return const ApiException('Request cancelled.');
      default:
        return const ApiException('Unexpected network error.');
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
