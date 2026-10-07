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
        return const ApiException('The server took too long to respond.');
      case DioExceptionType.connectionError:
        return const ApiException('Unable to reach the server.');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 404) {
          return ApiException('Resource not found.', statusCode: code);
        }
        return ApiException('Server error ($code).', statusCode: code);
      case DioExceptionType.cancel:
        return const ApiException('Request cancelled.');
      default:
        return const ApiException('Unexpected network error.');
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
