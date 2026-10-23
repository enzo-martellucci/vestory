import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class CollectionProgress extends StatelessWidget {
  final int owned;
  final int total;

  const CollectionProgress({super.key, required this.owned, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : owned / total;

    return Column(
      spacing: 6,
      children: [
        Row(
          children: [
            Text('$owned / $total collected', style: const TextStyle(fontWeight: .w700)),
            const Spacer(),
            Text('${(progress * 100).round()}%', style: const TextStyle(color: AppColors.muted)),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            color: AppColors.indigo,
            backgroundColor: AppColors.cardBorder,
          ),
        ),
      ],
    );
  }
}
