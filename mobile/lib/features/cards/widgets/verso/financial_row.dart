import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 1.5),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            formatValue(value, compact: compactNumber),
            style: const TextStyle(
              color: AppColors.textStrong,
              fontSize: 6,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  /// Fonction pure, testable sans widget.
  static String formatValue(double? value, {bool compact = false}) {
    if (value == null) return '—';

    if (compact) {
      if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(1)} Md';
      if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(1)} M';
      if (value >= 1e3) return '${(value / 1e3).toStringAsFixed(1)} k';
    }

    return value.toStringAsFixed(2);
  }
}
