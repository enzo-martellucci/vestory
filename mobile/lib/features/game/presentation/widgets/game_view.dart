import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/widgets/line_chart.dart';
import 'package:mobile/core/widgets/page_insets.dart';
import 'package:mobile/core/widgets/panel.dart';
import 'package:mobile/features/assets/presentation/asset_logo.dart';
import 'package:mobile/features/assets/presentation/asset_providers.dart';
import 'package:mobile/features/game/domain/game_rules.dart';
import 'package:mobile/features/game/domain/portfolio.dart';
import 'package:mobile/features/game/domain/trade_type.dart';
import 'package:mobile/features/game/presentation/sheets/sell_sheet.dart';
import 'package:mobile/features/game/presentation/widgets/game_header.dart';

class GameView extends ConsumerWidget {
  static const _floatingButtonSpace = 72.0;
  static const _visibleTrades = 12;

  final Portfolio portfolio;

  const GameView({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = {for (final asset in ref.watch(assetsProvider).value ?? const <Asset>[]) asset.id: asset};
    final trades = portfolio.trades.reversed.take(_visibleTrades).toList();

    return ListView(
      padding: pageInsets(context, extraBottom: _floatingButtonSpace),
      children: [
        GameHeader(portfolio: portfolio),
        const SizedBox(height: 16),
        Panel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Portfolio value', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              portfolio.curve.length < 2
                  ? const SizedBox(
                      height: 120,
                      child: Center(child: Text('Your curve appears after the first month.', style: TextStyle(color: AppColors.muted))),
                    )
                  : LineChart(
                      values: [for (final point in portfolio.curve) point.value],
                      color: AppColors.trend(portfolio.performance),
                      baseline: initialCash,
                    ),
            ],
          ),
        ),
        const SectionHeader('Holdings'),
        if (portfolio.holdings.isEmpty)
          const Panel(
            child: Text(
              'You have not invested yet. Tap Buy to put your cash to work with the assets of your collection.',
              style: TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ),
        for (final holding in portfolio.holdings) ...[
          _HoldingTile(holding: holding, onTap: () => showSellSheet(context, portfolio, holding)),
          const SizedBox(height: 10),
        ],
        if (trades.isNotEmpty) ...[
          const SectionHeader('Activity'),
          Panel(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                for (final trade in trades) _TradeTile(trade: trade, symbol: assets[trade.assetId]?.symbol ?? ''),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _HoldingTile extends StatelessWidget {
  final Holding holding;
  final VoidCallback onTap;

  const _HoldingTile({required this.holding, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: [
          AssetLogo(asset: holding.asset, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(holding.asset.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(
                  '${formatQuantity(holding.position.quantity)} × ${formatPrice(holding.price)}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatMoney(holding.value), style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(
                formatPercent(holding.gainPercent),
                style: TextStyle(color: AppColors.trend(holding.gain), fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TradeTile extends StatelessWidget {
  final Trade trade;
  final String symbol;

  const _TradeTile({required this.trade, required this.symbol});

  @override
  Widget build(BuildContext context) {
    final isBuy = trade.type == TradeType.buy;
    return ListTile(
      dense: true,
      leading: Icon(
        isBuy ? Icons.south_west_rounded : Icons.north_east_rounded,
        color: isBuy ? AppColors.primary : AppColors.positive,
      ),
      title: Text('${isBuy ? 'Bought' : 'Sold'} ${formatQuantity(trade.quantity)} $symbol', style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('at ${formatPrice(trade.price)} · ${trade.month.label}'),
      trailing: Text(formatMoney(trade.quantity * trade.price), style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
