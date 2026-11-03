import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/formatting/freshness.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/cards/data/models/asset.dart';
import 'package:mobile/features/cards/presentation/widgets/card_frame.dart';
import 'package:mobile/features/cards/presentation/widgets/financial_chart_preview.dart';
import 'package:mobile/features/market/data/models/financial_history.dart';
import 'package:mobile/features/market/data/models/financial_quote.dart';

class AssetCardBack extends StatelessWidget {
  final Asset card;
  final AsyncValue<FinancialQuote>? quote;
  final AsyncValue<FinancialHistory>? history;

  const AssetCardBack({
    super.key,
    required this.card,
    required this.quote,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return CardFrame(
      rarity: card.rarity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: _content(),
    );
  }

  Widget _content() {
    final color = card.rarity.color;

    return switch (quote) {
      null || AsyncLoading() => Center(
          child: CircularProgressIndicator(color: color, strokeWidth: 2),
        ),
      AsyncError(:final error) => _ErrorState(
          name: card.name,
          color: color,
          message: apiErrorMessage(error),
        ),
      AsyncData(value: final q) => _QuoteContent(
          name: card.name,
          quote: q,
          history: history,
          rarityColor: color,
        ),
    };
  }
}

class _QuoteContent extends StatelessWidget {
  static const _referenceWidth = 160.0;

  final String name;
  final FinancialQuote quote;
  final AsyncValue<FinancialHistory>? history;
  final Color rarityColor;

  const _QuoteContent({
    required this.name,
    required this.quote,
    required this.history,
    required this.rarityColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = (constraints.maxWidth / _referenceWidth).clamp(0.8, 2.0);

        return Column(
          crossAxisAlignment: .start,
          children: [
            _Header(name: name, quote: quote, scale: scale),
            SizedBox(height: 8 * scale),
            Expanded(
              flex: 5,
              child: FinancialChartPreview(history: history, rarityColor: rarityColor),
            ),
            SizedBox(height: 8 * scale),
            _Stats(quote: quote, scale: scale),
            SizedBox(height: 8 * scale),
            Container(height: 1, color: AppColors.divider),
            SizedBox(height: 6 * scale),
            _MarketStatus(marketOpen: quote.marketOpen, exchange: quote.exchange, scale: scale),
            SizedBox(height: 3 * scale),
            _Freshness(fetchedAt: quote.fetchedAt, scale: scale),
          ],
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final FinancialQuote quote;
  final double scale;

  const _Header({required this.name, required this.quote, required this.scale});

  @override
  Widget build(BuildContext context) {
    final changePercent = quote.changePercent;
    final trackedBy = quote.trackedBy;
    final trendColor = AppColors.trend(quote.isPositive);
    final currency = quote.currency;

    return Column(
      crossAxisAlignment: .start,
      spacing: 4 * scale,
      children: [
        Row(
          spacing: 5 * scale,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5 * scale, vertical: 2 * scale),
              decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(6 * scale)),
              child: Text(
                quote.symbol,
                style: TextStyle(color: Colors.white, fontSize: 8 * scale, fontWeight: .w900),
              ),
            ),
            Expanded(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 9 * scale, fontWeight: .w800),
              ),
            ),
          ],
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: quote.price.toStringAsFixed(2),
                style: TextStyle(color: AppColors.textPrimary, fontSize: 22 * scale, fontWeight: .w900, height: 1.1),
              ),
              if (currency != null && currency.isNotEmpty)
                TextSpan(
                  text: ' $currency',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 9 * scale, fontWeight: .w700),
                ),
            ],
          ),
        ),
        if (changePercent != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6 * scale, vertical: 2.5 * scale),
            decoration: BoxDecoration(
              color: trendColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: .min,
              spacing: 2 * scale,
              children: [
                Icon(quote.isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: trendColor, size: 12 * scale),
                Text(
                  _formattedChange(changePercent),
                  style: TextStyle(color: trendColor, fontSize: 8.5 * scale, fontWeight: .w800),
                ),
              ],
            ),
          ),
        if (trackedBy != null)
          Text(
            'Price via the $trackedBy ETF',
            style: TextStyle(color: AppColors.textMuted, fontSize: 7 * scale, fontWeight: .w600),
          ),
      ],
    );
  }

  String _formattedChange(double changePercent) {
    final sign = quote.isPositive ? '+' : '';
    final change = quote.change?.toStringAsFixed(2) ?? '—';
    return '$sign$change ($sign${changePercent.toStringAsFixed(2)}%)';
  }
}

class _Stats extends StatelessWidget {
  final FinancialQuote quote;
  final double scale;

  const _Stats({required this.quote, required this.scale});

  @override
  Widget build(BuildContext context) {
    final low = quote.low;
    final high = quote.high;
    final dayRange = low == null || high == null ? '—' : '${_format(low)} – ${_format(high)}';

    return Column(
      spacing: 5 * scale,
      children: [
        Row(
          spacing: 5 * scale,
          children: [
            _StatTile(label: 'Open', value: _format(quote.open), scale: scale),
            _StatTile(label: 'Prev. close', value: _format(quote.previousClose), scale: scale),
          ],
        ),
        Row(
          spacing: 5 * scale,
          children: [
            _StatTile(label: 'Day range', value: dayRange, scale: scale),
            _StatTile(label: 'Volume', value: _format(quote.volume, compact: true), scale: scale),
          ],
        ),
      ],
    );
  }

  static String _format(double? value, {bool compact = false}) {
    if (value == null)
      return '—';
    if (compact && value >= 1e9)
      return '${(value / 1e9).toStringAsFixed(1)}B';
    if (compact && value >= 1e6)
      return '${(value / 1e6).toStringAsFixed(1)}M';
    if (compact && value >= 1e3)
      return '${(value / 1e3).toStringAsFixed(1)}K';
    return value.toStringAsFixed(2);
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final double scale;

  const _StatTile({required this.label, required this.value, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6 * scale, vertical: 4 * scale),
        decoration: BoxDecoration(
          color: AppColors.cardFallbackSurface,
          borderRadius: BorderRadius.circular(8 * scale),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 7 * scale, fontWeight: .w600)),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textStrong, fontSize: 9 * scale, fontWeight: .w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketStatus extends StatelessWidget {
  final bool marketOpen;
  final String? exchange;
  final double scale;

  const _MarketStatus({required this.marketOpen, this.exchange, required this.scale});

  @override
  Widget build(BuildContext context) {
    final exchange = this.exchange;
    final style = TextStyle(color: AppColors.textSecondary, fontSize: 7.5 * scale, fontWeight: .w600);

    return Row(
      spacing: 4 * scale,
      children: [
        Container(
          width: 6 * scale,
          height: 6 * scale,
          decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.trend(marketOpen)),
        ),
        Text(marketOpen ? 'Market open' : 'Market closed', style: style),
        const Spacer(),
        if (exchange != null && exchange.isNotEmpty)
          Text(exchange, style: style.copyWith(fontWeight: .w800)),
      ],
    );
  }
}

class _Freshness extends StatelessWidget {
  final DateTime? fetchedAt;
  final double scale;

  const _Freshness({required this.fetchedAt, required this.scale});

  @override
  Widget build(BuildContext context) {
    final fetchedAt = this.fetchedAt;
    if (fetchedAt == null)
      return const SizedBox.shrink();

    final now = DateTime.now();
    final stale = !isSameDay(fetchedAt.toLocal(), now);
    final color = stale ? AppColors.negative : AppColors.textMuted;

    return Row(
      spacing: 4 * scale,
      children: [
        Icon(stale ? Icons.cloud_off_rounded : Icons.schedule_rounded, size: 8 * scale, color: color),
        Expanded(
          child: Text(
            freshnessLabel(fetchedAt, now),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 7 * scale, fontWeight: .w500),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String name;
  final Color color;
  final String? message;

  const _ErrorState({
    required this.name,
    required this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.show_chart_rounded, color: color, size: 30),
        const SizedBox(height: 10),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Market data unavailable.\nFlip again to retry.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 7),
        ),
        if (message != null) ...[
          const SizedBox(height: 6),
          Text(
            message!,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 6),
          ),
        ],
      ],
    );
  }
}
