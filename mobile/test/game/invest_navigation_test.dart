import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/router/main_shell.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/assets/presentation/asset_providers.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/domain/portfolio.dart';
import 'package:mobile/features/game/presentation/game_providers.dart';
import 'package:mobile/features/game/presentation/invest_screen.dart';

import '../fixtures.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pumpInvest(WidgetTester tester) async {
    final portfolio = Portfolio(
      game: game(startedAt: DateTime(2026, 1, 1)),
      month: const YearMonth(2010, 1),
      elapsedMonths: 0,
      cash: initialCash,
      holdings: const [],
      curve: const [],
      trades: const [],
    );
    final router = GoRouter(
      initialLocation: '/invest',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) => MainShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(routes: [GoRoute(path: '/invest', builder: (context, state) => const InvestScreen())]),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          portfolioProvider.overrideWith((ref) => portfolio),
          assetsProvider.overrideWith((ref) => Stream.value([asset(1, quantity: 1)])),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('the Buy button stays above the navigation bar', (tester) async {
    await pumpInvest(tester);

    final button = tester.getRect(find.byType(FloatingActionButton));
    final navigationBar = tester.getRect(find.byIcon(Icons.home_rounded));
    expect(button.bottom, lessThanOrEqualTo(navigationBar.top));
  });

  testWidgets('the buy sheet opens above the navigation bar', (tester) async {
    await pumpInvest(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final sheet = find.text('Buy an asset');
    expect(sheet, findsOneWidget);
    expect(find.ancestor(of: sheet, matching: find.byType(MainShell)), findsNothing);
  });
}
