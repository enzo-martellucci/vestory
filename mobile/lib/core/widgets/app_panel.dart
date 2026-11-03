import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class AppPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppPanel({super.key, required this.child, this.padding = const EdgeInsets.all(20)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [BoxShadow(color: AppColors.indigo.withValues(alpha: 0.07), blurRadius: 24, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }
}
