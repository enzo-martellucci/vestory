import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

class Floating extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final Duration period;
  final double phase;

  const Floating({
    super.key,
    required this.child,
    this.amplitude = 6,
    this.period = const Duration(milliseconds: 2400),
    this.phase = 0,
  });

  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: widget.period)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, math.sin((_controller.value + widget.phase) * 2 * math.pi) * widget.amplitude),
        child: child,
      ),
      child: widget.child,
    );
  }
}
