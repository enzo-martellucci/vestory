import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/user/data/models/user_response.dart';
import 'package:mobile/features/user/data/user_repository.dart';

final currentUserProvider = FutureProvider.autoDispose<UserResponse>(
  (ref) => ref.watch(userRepositoryProvider).getCurrentUser(),
);
