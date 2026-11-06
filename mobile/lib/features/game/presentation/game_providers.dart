import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/time/clock.dart';
import 'package:mobile/core/time/year_month.dart';
import 'package:mobile/features/assets/presentation/asset_providers.dart';
import 'package:mobile/features/game/data/game_repository.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/domain/portfolio.dart';
import 'package:mobile/features/market/domain/price_history.dart';
import 'package:mobile/features/market/presentation/market_providers.dart';

final currentGameProvider = StreamProvider<Game?>((ref) => ref.watch(gameRepositoryProvider).watchCurrent());

final finishedGamesProvider = StreamProvider<List<Game>>((ref) => ref.watch(gameRepositoryProvider).watchFinished());

final tradesProvider = StreamProvider.family<List<Trade>, int>((ref, gameId) => ref.watch(gameRepositoryProvider).watchTrades(gameId));

final portfolioProvider = FutureProvider.autoDispose<Portfolio?>((ref) async {
  final game = await ref.watch(currentGameProvider.future);
  if (game == null)
    return null;

  final trades = await ref.watch(tradesProvider(game.id).future);
  final assets = await ref.watch(assetsProvider.future);
  final now = ref.watch(clockProvider)();
  final histories = <int, PriceHistory>{
    for (final assetId in {for (final trade in trades) trade.assetId})
      assetId: await ref.watch(priceHistoryProvider(assetId).future),
  };

  double? price(int assetId, YearMonth month) => histories[assetId]?.priceAt(month);
  final month = game.currentMonth(now);
  final assetsById = {for (final asset in assets) asset.id: asset};
  final holdings = [
    for (final position in positionsAt(trades).values)
      Holding(
        asset: assetsById[position.assetId]!,
        position: position,
        price: price(position.assetId, month) ?? position.averagePrice,
      ),
  ]..sort((a, b) => b.value.compareTo(a.value));

  final portfolio = Portfolio(
    game: game,
    month: month,
    elapsedMonths: game.elapsedMonths(now),
    cash: cashAt(trades, month),
    holdings: holdings,
    curve: valueCurve(start: game.startMonth, current: month, trades: trades, price: price),
    trades: trades,
  );

  if (game.isOver(now))
    await ref.read(gameRepositoryProvider).end(gameId: game.id, finalValue: portfolio.totalValue, endedAt: now);

  return portfolio;
});
