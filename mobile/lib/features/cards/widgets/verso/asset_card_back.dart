import 'package:flutter/material.dart';

import '../../../market/models/financial_history.dart';
import '../../../market/models/financial_quote.dart';
import '../../models/asset_card_model.dart';

import 'financial_card_header.dart';
import 'financial_chart_preview.dart';
import 'financial_error_state.dart';
import 'financial_stats.dart';
import 'market_status.dart';

class AssetCardBack extends StatelessWidget {
  final AssetCardModel card;

  final FinancialQuote? quote;
  final bool loading;
  final Object? error;

  final FinancialHistory? history;
  final bool historyLoading;
  final Object? historyError;

  const AssetCardBack({
    super.key,
    required this.card,

    required this.quote,
    required this.loading,
    required this.error,

    required this.history,
    required this.historyLoading,
    required this.historyError,
  });

  Color get rarityColor {
    switch (card.rarity) {
      case 'LEGENDARY':
        return const Color(0xFFD8A73D);

      case 'EPIC':
        return const Color(0xFF8B5CF6);

      case 'RARE':
        return const Color(0xFF4C7DFF);

      default:
        return const Color(0xFF69C6A4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),

      decoration: BoxDecoration(
        color: rarityColor,
        borderRadius: BorderRadius.circular(30),

        boxShadow: [
          BoxShadow(
            color: rarityColor.withValues(
              alpha: 0.28,
            ),
            blurRadius: 22,
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),

        child: Container(
          color: const Color(0xFFF8F8F6),

          padding: const EdgeInsets.fromLTRB(
            14,
            14,
            14,
            12,
          ),

          child: _content(),
        ),
      ),
    );
  }

  Widget _content() {
    // On bloque le verso uniquement
    // pendant le chargement de la QUOTE.
    if (loading) {
      return Center(
        child: CircularProgressIndicator(
          color: rarityColor,
          strokeWidth: 2,
        ),
      );
    }

    // Seule une erreur de QUOTE
    // rend les données financières indisponibles.
    if (error != null || quote == null) {
      return FinancialErrorState(
        name: card.name,
        color: rarityColor,
      );
    }

    final q = quote!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FinancialCardHeader(
          name: card.name,
          quote: q,
        ),

        const SizedBox(height: 10),

        Expanded(
          flex: 4,
          child: FinancialChartPreview(
            points: history?.points ?? const [],
            loading: historyLoading,
            error: historyError,
            rarityColor: rarityColor,
          ),
        ),

        const SizedBox(height: 8),

        Expanded(
          flex: 6,
          child: Column(
            children: [
              FinancialStats(
                quote: q,
              ),

              const Spacer(),

              Container(
                height: 1,
                color: const Color(
                  0xFFDADAD7,
                ),
              ),

              const SizedBox(height: 7),

              MarketStatus(
                marketOpen: q.marketOpen,
                exchange: q.exchange,
              ),
            ],
          ),
        ),
      ],
    );
  }
}