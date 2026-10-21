import 'package:mobile/core/network/api_exception.dart';

String apiErrorMessage(Object error) => switch (error) {
  NetworkException() => 'No internet connection',
  ResponseException(:final error) => error.detail ?? 'Something went wrong',
  _ => 'Something went wrong',
};
