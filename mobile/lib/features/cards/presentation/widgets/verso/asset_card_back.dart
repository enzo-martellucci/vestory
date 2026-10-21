import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/network/api_error_message.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/cards/data/models/asset_card_model.dart';
import 'package:mobile/features/cards/presentation/widgets/card_frame.dart';
import 'package:mobile/features/cards/presentation/widgets/verso/data_freshness.dart';
import 'package:mobile/features/cards/presentation/widgets/verso/financial_card_header.dart';
import 'package:mobile/features/cards/presentation/widgets/verso/financial_chart_preview.dart';
import 'package:mobile/features/cards/presentation/widgets/verso/financial_error_state.dart';
import 'package:mobile/features/cards/presentation/widgets/verso/financial_stats.dart';
import 'package:mobile/features/cards/presentation/widgets/verso/market_status.dart';
import 'package:mobile/features/market/data/models/financial_history.dart';
import 'package:mobile/features/market/data/models/financial_quote.dart';

class AssetCardBack extends StatelessWidget {
  final AssetCardModel card;
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
      AsyncError(:final error) => FinancialErrorState(
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FinancialCardHeader(name: name, quote: quote),
        const SizedBox(height: 10),
        Expanded(
          flex: 4,
          child: FinancialChartPreview(
            history: history,
            rarityColor: rarityColor,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          flex: 6,
          child: Column(
            children: [
              FinancialStats(quote: quote),
              const Spacer(),
              Container(height: 1, color: AppColors.divider),
              const SizedBox(height: 7),
              MarketStatus(
                marketOpen: quote.marketOpen,
                exchange: quote.exchange,
              ),
              const SizedBox(height: 4),
              DataFreshness(fetchedAt: quote.fetchedAt),
            ],
          ),
        ),
      ],
    );
  }
}
