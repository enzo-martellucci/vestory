import 'package:flutter/material.dart';

class MarketStatus extends StatelessWidget {
  final bool marketOpen;
  final String? exchange;

  const MarketStatus({
    super.key,
    required this.marketOpen,
    this.exchange,
  });

  @override
  Widget build(BuildContext context) {
    final color = marketOpen
        ? const Color(0xFF159B61)
        : const Color(0xFFD94B4B);

    return Row(
      children: [
        if (exchange != null &&
            exchange!.isNotEmpty) ...[
          Text(
            exchange!,
            style: const TextStyle(
              color: Color(0xFF777777),
              fontSize: 6,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),
        ],

        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),

        const SizedBox(width: 5),

        Text(
        marketOpen
            ? 'Market open'
            : 'Market closed',
          style: const TextStyle(
            color: Color(0xFF777777),
            fontSize: 6,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}