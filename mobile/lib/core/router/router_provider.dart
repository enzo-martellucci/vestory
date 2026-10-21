import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/router/main_shell.dart';
import 'package:mobile/core/widgets/placeholder_screen.dart';
import 'package:mobile/features/auth/presentation/auth_notifier.dart';
import 'package:mobile/features/auth/presentation/login_screen.dart';
import 'package:mobile/features/auth/presentation/register_screen.dart';
import 'package:mobile/features/auth/presentation/splash_screen.dart';
import 'package:mobile/features/cards/presentation/cards_screen.dart';
import 'package:mobile/features/profile/presentation/profile_screen.dart';
import 'package:mobile/home_page.dart';

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
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const HomePage())]),
          StatefulShellBranch(routes: [GoRoute(path: '/collection', builder: (context, state) => const CardsScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/shop', builder: (context, state) => const PlaceholderScreen(title: 'Shop'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/invest', builder: (context, state) => const PlaceholderScreen(title: 'Invest'))]),
          StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen())]),
        ],
      ),
    ],
  );
});
