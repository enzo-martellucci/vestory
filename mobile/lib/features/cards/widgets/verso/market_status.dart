import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class MarketStatus extends StatelessWidget {
  final bool marketOpen;
  final String? exchange;

  const MarketStatus({super.key, required this.marketOpen, this.exchange});

  static const _labelStyle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 6,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    final exchange = this.exchange;

    return Row(
      children: [
        if (exchange != null && exchange.isNotEmpty) ...[
          Text(
            exchange,
            style: _labelStyle.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
        ],
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.trend(marketOpen),
          ),
        ),
        const SizedBox(width: 5),
        Text(marketOpen ? 'Market open' : 'Market closed', style: _labelStyle),
      ],
    );
  }
}
