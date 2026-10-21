import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class HomePanel extends StatelessWidget {
  final Widget child;

  const HomePanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: child,
    );
  }
}
