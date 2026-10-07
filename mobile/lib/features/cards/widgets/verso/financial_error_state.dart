import 'package:flutter/material.dart';

class FinancialErrorState
    extends StatelessWidget {
  final String name;
  final Color color;

  const FinancialErrorState({
    super.key,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        Icon(
          Icons.show_chart_rounded,
          color: color,
          size: 30,
        ),

        const SizedBox(height: 10),

        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF181818),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Market data unavailable.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF777777),
            fontSize: 7,
          ),
        ),
      ],
    );
  }
}