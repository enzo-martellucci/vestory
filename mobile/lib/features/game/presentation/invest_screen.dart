import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/time/clock.dart';
import 'package:mobile/core/widgets/panel.dart';
import 'package:mobile/features/game/data/game_repository.dart';
import 'package:mobile/features/game/domain/portfolio.dart';
import 'package:mobile/features/game/presentation/game_providers.dart';
import 'package:mobile/features/game/presentation/sheets/buy_sheet.dart';
import 'package:mobile/features/game/presentation/widgets/game_view.dart';
import 'package:mobile/features/game/presentation/widgets/no_game_view.dart';
import 'package:mobile/features/market/presentation/market_providers.dart';

class InvestScreen extends ConsumerWidget {
  const InvestScreen({super.key});

  Future<void> _endGame(BuildContext context, WidgetRef ref, Portfolio portfolio) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End this game?'),
        content: Text('Your portfolio will be closed at ${formatMoney(portfolio.totalValue)}.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Keep playing')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('End game')),
        ],
      ),
    );
    if (confirmed == true)
      await ref.read(gameRepositoryProvider).end(gameId: portfolio.game.id, finalValue: portfolio.totalValue, endedAt: ref.read(clockProvider)());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolio = ref.watch(portfolioProvider);
    final current = portfolio.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invest'),
        actions: [
          if (current != null)
            IconButton(
              tooltip: 'End game',
              onPressed: () => _endGame(context, ref, current),
              icon: const Icon(Icons.flag_rounded),
            ),
        ],
      ),
      floatingActionButton: current == null
          ? null
          : Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
              child: FloatingActionButton.extended(
                onPressed: () => showBuySheet(context, current),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Buy'),
              ),
            ),
      body: portfolio.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: ErrorView(
            error: error,
            onRetry: () {
              ref.invalidate(priceHistoryProvider);
              ref.invalidate(portfolioProvider);
            },
          ),
        ),
        data: (portfolio) => portfolio == null ? const NoGameView() : GameView(portfolio: portfolio),
      ),
    );
  }
}
