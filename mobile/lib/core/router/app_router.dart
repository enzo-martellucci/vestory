import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/router/main_shell.dart';
import 'package:mobile/features/collection/presentation/collection_screen.dart';
import 'package:mobile/features/game/presentation/invest_screen.dart';
import 'package:mobile/features/home/presentation/home_screen.dart';
import 'package:mobile/features/packs/domain/daily_pack.dart';
import 'package:mobile/features/packs/domain/pack_type.dart';
import 'package:mobile/features/packs/presentation/opening/pack_opening_screen.dart';
import 'package:mobile/features/shop/presentation/shop_screen.dart';
import 'package:mobile/features/player/presentation/onboarding_screen.dart';
import 'package:mobile/features/player/presentation/player_providers.dart';
import 'package:mobile/features/player/presentation/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final player = ValueNotifier<AsyncValue<Player?>>(const AsyncLoading());
  ref.onDispose(player.dispose);
  ref.listen(playerProvider, (_, next) => player.value = next, fireImmediately: true);

  return GoRouter(
    initialLocation: '/home',
    refreshListenable: player,
    redirect: (context, state) {
      final value = player.value;
      final location = state.matchedLocation;
      if (!value.hasValue)
        return location == '/loading' ? null : '/loading';
      if (value.value == null)
        return location == '/welcome' ? null : '/welcome';
      if (location == '/welcome' || location == '/loading')
        return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/loading', builder: (context, state) => const Scaffold(body: Center(child: CircularProgressIndicator()))),
      GoRoute(path: '/welcome', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/open/daily', builder: (context, state) => const PackOpeningScreen(type: dailyPackType, isDaily: true)),
      GoRoute(
        path: '/open/:type',
        builder: (context, state) => PackOpeningScreen(type: PackType.values.byName(state.pathParameters['type']!)),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (context, state) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/collection', builder: (context, state) => const CollectionScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/shop', builder: (context, state) => const ShopScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/invest', builder: (context, state) => const InvestScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen())]),
        ],
      ),
    ],
  );
});
