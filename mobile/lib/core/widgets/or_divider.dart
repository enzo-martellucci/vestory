import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 12,
      children: [
        Expanded(child: Divider(color: AppColors.fieldBorder)),
        Text('or', style: TextStyle(fontSize: 13, color: AppColors.muted)),
        Expanded(child: Divider(color: AppColors.fieldBorder)),
      ],
    );
  }
}
