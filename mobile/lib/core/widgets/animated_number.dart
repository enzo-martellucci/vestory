import 'package:material_ui/material_ui.dart';

class AnimatedNumber extends StatelessWidget {
  final double value;
  final String Function(double value) format;
  final TextStyle? style;

  const AnimatedNumber({super.key, required this.value, required this.format, this.style});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) => Text(format(animated), style: style),
    );
  }
}
