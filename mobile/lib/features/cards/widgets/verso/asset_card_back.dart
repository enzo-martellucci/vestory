import 'package:flutter/material.dart';

import '../../../../core/state/async_value.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../market/models/financial_history.dart';
import '../../../market/models/financial_quote.dart';
import '../../models/asset_card_model.dart';
import '../card_frame.dart';
import 'financial_card_header.dart';
import 'financial_chart_preview.dart';
import 'financial_error_state.dart';
import 'financial_stats.dart';
import 'market_status.dart';

class AssetCardBack extends StatelessWidget {
  final AssetCardModel card;

  /// `null` = pas encore demandé (affiché comme un chargement).
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

    // Seule la COTATION conditionne l'affichage du verso ;
    // l'historique a son propre état dans la zone du graphique.
    return switch (quote) {
      null || AsyncLoading() => Center(
          child: CircularProgressIndicator(color: color, strokeWidth: 2),
        ),
      AsyncError() => FinancialErrorState(name: card.name, color: color),
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
            ],
          ),
        ),
      ],
    );
  }
}
