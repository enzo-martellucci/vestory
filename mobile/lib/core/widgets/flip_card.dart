import 'dart:math' as math;

import 'package:flutter/material.dart';

// gere l'animation de la carte qui se retourne
class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final ValueChanged<bool>? onFlip;
  final Duration duration;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    this.onFlip,
    this.duration = const Duration(milliseconds: 550),
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutCubic,
  );

  bool get _isBackTarget =>
      _controller.status == AnimationStatus.forward ||
      _controller.status == AnimationStatus.completed;

  void _toggle() {
    final showBack = !_isBackTarget;
    if (showBack) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    widget.onFlip?.call(showBack);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final angle = _animation.value * math.pi;
          final showFront = angle < math.pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0014)
              ..rotateY(angle),
            child: showFront
                ? widget.front
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: widget.back,
                  ),
          );
        },
      ),
    );
  }
}
