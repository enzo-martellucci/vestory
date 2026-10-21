import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_exception.dart';
import 'package:mobile/core/network/dio_provider.dart';
import 'package:mobile/features/user/data/models/user_response.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository(dio: ref.watch(dioProvider)));

class UserRepository {
  final Dio dio;

  UserRepository({required this.dio});

  Future<UserResponse> getCurrentUser() async {
    try {
      final response = await dio.get('/api/users/me');
      return UserResponse.fromJson(response.data);
    } on DioException catch (exception) {
      throw exception.toApiException();
    }
  }
}
