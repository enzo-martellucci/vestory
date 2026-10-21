import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class LegendaryRays extends StatefulWidget {
  final double size;

  const LegendaryRays({super.key, this.size = 560});

  @override
  State<LegendaryRays> createState() => _LegendaryRaysState();
}

class _LegendaryRaysState extends State<LegendaryRays> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      builder: (context, opacity, child) => Opacity(opacity: opacity, child: child),
      child: OverflowBox(
        maxWidth: double.infinity,
        maxHeight: double.infinity,
        child: RotationTransition(
          turns: _controller,
          child: CustomPaint(size: Size.square(widget.size), painter: _RaysPainter()),
        ),
      ),
    );
  }
}

class _RaysPainter extends CustomPainter {
  static const _rayCount = 14;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [AppColors.legendary.withValues(alpha: 0.7), AppColors.legendary.withValues(alpha: 0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    const halfWidth = math.pi / _rayCount / 2.5;
    for (var index = 0; index < _rayCount; index++) {
      final angle = index * 2 * math.pi / _rayCount;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..lineTo(center.dx + math.cos(angle - halfWidth) * radius, center.dy + math.sin(angle - halfWidth) * radius)
        ..lineTo(center.dx + math.cos(angle + halfWidth) * radius, center.dy + math.sin(angle + halfWidth) * radius)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_RaysPainter oldDelegate) => false;
}

class SparkleRain extends StatefulWidget {
  final int count;

  const SparkleRain({super.key, this.count = 36});

  @override
  State<SparkleRain> createState() => _SparkleRainState();
}

class _SparkleRainState extends State<SparkleRain> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  late final List<_Sparkle> _sparkles;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _sparkles = List.generate(
      widget.count,
      (_) => _Sparkle(
        x: random.nextDouble(),
        offset: random.nextDouble(),
        speed: 0.6 + random.nextDouble() * 0.8,
        radius: 1.5 + random.nextDouble() * 2.5,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _SparklePainter(_controller, _sparkles), size: Size.infinite);
  }
}

class _Sparkle {
  final double x;
  final double offset;
  final double speed;
  final double radius;

  const _Sparkle({required this.x, required this.offset, required this.speed, required this.radius});
}

class _SparklePainter extends CustomPainter {
  final Animation<double> progress;
  final List<_Sparkle> sparkles;

  _SparklePainter(this.progress, this.sparkles) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final sparkle in sparkles) {
      final t = (progress.value * sparkle.speed + sparkle.offset) % 1;
      final twinkle = 0.5 + 0.5 * math.sin((t + sparkle.offset) * math.pi * 12);
      final position = Offset(sparkle.x * size.width, t * size.height);
      paint.color = Color.lerp(AppColors.legendary, Colors.white, twinkle * 0.5)!.withValues(alpha: (1 - t) * twinkle);
      canvas.drawCircle(position, sparkle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) => false;
}
