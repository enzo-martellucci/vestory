import 'package:flutter/material.dart';

class FinancialRow extends StatelessWidget {
  final String label;
  final double? value;
  final bool compactNumber;

  const FinancialRow({
    super.key,
    required this.label,
    required this.value,
    this.compactNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 1.5,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF777777),
              fontSize: 6,
              fontWeight:
              FontWeight.w500,
            ),
          ),

          const Spacer(),

          Text(
            _displayValue(),
            style: const TextStyle(
              color: Color(0xFF282828),
              fontSize: 6,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _displayValue() {
    if (value == null) {
      return '—';
    }

    if (compactNumber) {
      if (value! >= 1000000000) {
        return '${(value! / 1000000000).toStringAsFixed(1)} Md';
      }

      if (value! >= 1000000) {
        return '${(value! / 1000000).toStringAsFixed(1)} M';
      }

      if (value! >= 1000) {
        return '${(value! / 1000).toStringAsFixed(1)} k';
      }
    }

    return value!.toStringAsFixed(2);
  }
}