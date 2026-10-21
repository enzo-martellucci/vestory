import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/market/data/models/financial_quote.dart';

class FinancialCardHeader extends StatelessWidget {
  final String name;
  final FinancialQuote quote;

  const FinancialCardHeader({
    super.key,
    required this.name,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    final changePercent = quote.changePercent;
    final trackedBy = quote.trackedBy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 8,
            height: 1.08,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (trackedBy != null) ...[
          const SizedBox(height: 3),
          Text(
            'Price via the $trackedBy ETF',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 6,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                _formattedPrice(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (changePercent != null)
              Text(
                _formattedChange(changePercent),
                style: TextStyle(
                  color: AppColors.trend(quote.isPositive),
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _formattedPrice() {
    final price = quote.price.toStringAsFixed(2);
    final currency = quote.currency;
    return (currency == null || currency.isEmpty) ? price : '$price $currency';
  }

  String _formattedChange(double changePercent) {
    final sign = quote.isPositive ? '+' : '';
    final change = quote.change?.toStringAsFixed(2) ?? '—';
    return '$sign$change ($sign${changePercent.toStringAsFixed(2)}%)';
  }
}
