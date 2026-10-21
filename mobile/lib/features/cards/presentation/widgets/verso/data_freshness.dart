import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/formatting/freshness.dart';
import 'package:mobile/core/theme/app_colors.dart';

class DataFreshness extends StatelessWidget {
  final DateTime? fetchedAt;

  const DataFreshness({super.key, required this.fetchedAt});

  @override
  Widget build(BuildContext context) {
    final fetchedAt = this.fetchedAt;
    if (fetchedAt == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final stale = !isSameDay(fetchedAt.toLocal(), now);
    final color = stale ? AppColors.negative : AppColors.textMuted;

    return Row(
      children: [
        Icon(
          stale ? Icons.cloud_off_rounded : Icons.schedule_rounded,
          size: 7,
          color: color,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            freshnessLabel(fetchedAt, now),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}