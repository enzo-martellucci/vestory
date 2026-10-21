import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class FinancialErrorState extends StatelessWidget {
  final String name;
  final Color color;
  final String? message;

  const FinancialErrorState({
    super.key,
    required this.name,
    required this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.show_chart_rounded, color: color, size: 30),
        const SizedBox(height: 10),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Market data unavailable.\nFlip again to retry.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 7),
        ),
        if (message != null) ...[
          const SizedBox(height: 6),
          Text(
            message!,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 6),
          ),
        ],
      ],
    );
  }
}
