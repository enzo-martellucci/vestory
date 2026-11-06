import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/format/formatters.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/widgets/line_chart.dart';
import 'package:mobile/core/widgets/panel.dart';
import 'package:mobile/features/assets/presentation/asset_logo.dart';
import 'package:mobile/features/assets/presentation/asset_style.dart';
import 'package:mobile/features/market/presentation/market_providers.dart';

Future<void> showAssetDetailSheet(BuildContext context, Asset asset) => showModalBottomSheet(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  builder: (context) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: 0.85,
    maxChildSize: 0.95,
    builder: (context, controller) => _AssetDetail(asset: asset, controller: controller),
  ),
);

class _AssetDetail extends ConsumerWidget {
  final Asset asset;
  final ScrollController controller;

  const _AssetDetail({required this.asset, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final facts = {
      'Type': asset.type.label,
      'Sector': ?asset.sector,
      'Industry': ?asset.industry,
      'Country': ?asset.country,
      'Exchange': ?asset.exchange,
      'Currency': ?asset.currency,
    };

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        Row(
          children: [
            AssetLogo(asset: asset, size: 56),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(asset.name, style: AppTheme.display(20)),
                  const SizedBox(height: 4),
                  Text('${asset.symbol} · ${asset.rarity.label}', style: TextStyle(color: asset.rarity.color, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _QuotePanel(asset: asset),
        const SizedBox(height: 12),
        _HistoryPanel(asset: asset),
        const SectionHeader('About'),
        Panel(
          child: Column(
            children: [
              for (final fact in facts.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Text(fact.key, style: const TextStyle(color: AppColors.muted)),
                      const SizedBox(width: 16),
                      Expanded(child: Text(fact.value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w600))),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (asset.description != null) ...[
          const SizedBox(height: 12),
          Panel(child: Text(asset.description!, style: const TextStyle(height: 1.5))),
        ],
      ],
    );
  }
}

class _QuotePanel extends ConsumerWidget {
  final Asset asset;

  const _QuotePanel({required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Panel(
      child: ref.watch(quoteProvider(asset.id)).when(
        loading: () => const SizedBox(height: 64, child: Center(child: CircularProgressIndicator())),
        error: (error, _) => ErrorView(error: error, onRetry: () => ref.invalidate(quoteProvider(asset.id))),
        data: (quote) => Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Today on the market', style: TextStyle(color: AppColors.muted, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(formatPrice(quote.price), style: AppTheme.display(28)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatPercent(quote.changePercent),
                  style: TextStyle(color: AppColors.trend(quote.change), fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(quote.isMarketOpen ? 'Market open' : 'Market closed', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryPanel extends ConsumerWidget {
  final Asset asset;

  const _HistoryPanel({required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Panel(
      child: ref.watch(priceHistoryProvider(asset.id)).when(
        loading: () => const SizedBox(height: 160, child: Center(child: CircularProgressIndicator())),
        error: (error, _) => ErrorView(error: error, onRetry: () => ref.invalidate(priceHistoryProvider(asset.id))),
        data: (history) {
          if (history.points.length < 2)
            return const Text('No price history available.');

          final first = history.points.first;
          final last = history.points.last;
          final change = last.price / first.price - 1;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Since ${first.month.label}',
                      style: const TextStyle(color: AppColors.muted, fontSize: 13),
                    ),
                  ),
                  Text(formatPercent(change), style: TextStyle(color: AppColors.trend(change), fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 12),
              LineChart(values: [for (final point in history.points) point.price], color: asset.rarity.color),
            ],
          );
        },
      ),
    );
  }
}
