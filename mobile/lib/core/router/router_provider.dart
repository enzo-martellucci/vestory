import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/app_shell.dart';
import 'package:mobile/features/auth/presentation/auth_notifier.dart';
import 'package:mobile/features/auth/presentation/login_screen.dart';
import 'package:mobile/features/auth/presentation/register_screen.dart';
import 'package:mobile/features/auth/presentation/splash_screen.dart';
import 'package:mobile/features/cards/presentation/cards_screen.dart';
import 'package:mobile/features/home/presentation/home_screen.dart';
import 'package:mobile/features/shop/presentation/shop_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ValueNotifier<AsyncValue<bool>>(const AsyncLoading());
  ref.onDispose(authState.dispose);
  ref.listen(authProvider, (_, next) => authState.value = next, fireImmediately: true);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authState,
    redirect: (context, state) {
      final auth = authState.value;
      if (auth.isLoading)
        return '/splash';

      final isAuthenticated = auth.value ?? false;
      final location = state.matchedLocation;
      final isPublicLocation = location == '/login' || location == '/register';
      if (!isAuthenticated)
        return isPublicLocation ? null : '/login';
      if (isPublicLocation || location == '/splash')
        return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/cards', builder: (context, state) => const CardsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/shop', builder: (context, state) => const ShopScreen())]),
        ],
      ),
    ],
  );
});
