import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/storage/token_storage.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/data/models/login_request.dart';
import 'package:mobile/features/auth/data/models/register_request.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final refreshToken = await ref.watch(tokenStorageProvider).readRefreshToken();
    return refreshToken != null;
  }

  Future<void> login(LoginRequest request) async {
    await ref.read(authRepositoryProvider).login(request);
    state = const AsyncData(true);
  }

  Future<void> register(RegisterRequest request) async {
    await ref.read(authRepositoryProvider).register(request);
    state = const AsyncData(true);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(false);
  }

  void expireSession() {
    state = const AsyncData(false);
  }
}
