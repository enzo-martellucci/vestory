import 'package:flutter/material.dart';

import '../../../market/models/financial_quote.dart';
import 'financial_row.dart';

class FinancialStats extends StatelessWidget {
  final FinancialQuote quote;

  const FinancialStats({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FinancialRow(label: 'Open', value: quote.open),
        FinancialRow(label: 'High', value: quote.high),
        FinancialRow(label: 'Low', value: quote.low),
        FinancialRow(label: 'Previous close', value: quote.previousClose),
        FinancialRow(label: 'Change', value: quote.change),
        FinancialRow(label: 'Volume', value: quote.volume, compactNumber: true),
      ],
    );
  }
}
