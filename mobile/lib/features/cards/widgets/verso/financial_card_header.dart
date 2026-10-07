import 'package:flutter/material.dart';

import '../../../market/models/financial_quote.dart';

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
    final positive =
        (quote.changePercent ?? 0) >= 0;

    final changeColor = positive
        ? const Color(0xFF159B61)
        : const Color(0xFFD94B4B);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFF181818),
            fontSize: 8,
            height: 1.08,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                _formattedPrice(),
                style: const TextStyle(
                  color: Color(0xFF181818),
                  fontSize: 12,
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),

            if (quote.changePercent != null)
              Text(
                '${positive ? '+' : ''}'
                    '${quote.change?.toStringAsFixed(2) ?? '—'} '
                    '(${positive ? '+' : ''}'
                    '${quote.changePercent!.toStringAsFixed(2)}%)',
                style: TextStyle(
                  color: changeColor,
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
    final price =
    quote.price.toStringAsFixed(2);

    if (quote.currency == null ||
        quote.currency!.isEmpty) {
      return price;
    }

    return '$price ${quote.currency}';
  }
}