import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class ParticleBurst extends StatefulWidget {
  final Color color;
  final int count;

  const ParticleBurst({super.key, required this.color, required this.count});

  @override
  State<ParticleBurst> createState() => _ParticleBurstState();
}

class _ParticleBurstState extends State<ParticleBurst> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..forward();
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _particles = List.generate(
      widget.count,
      (_) => _Particle(
        angle: random.nextDouble() * 2 * math.pi,
        speed: 150 + random.nextDouble() * 350,
        radius: 2 + random.nextDouble() * 4,
        color: Color.lerp(widget.color, Colors.white, random.nextDouble() * 0.6)!,
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
    return CustomPaint(painter: _ParticlePainter(_controller, _particles), size: Size.infinite);
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double radius;
  final Color color;

  const _Particle({required this.angle, required this.speed, required this.radius, required this.color});
}

class _ParticlePainter extends CustomPainter {
  static const _gravity = 420.0;

  final Animation<double> progress;
  final List<_Particle> particles;

  _ParticlePainter(this.progress, this.particles) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t == 0 || t == 1)
      return;

    final seconds = t * 1.4;
    final center = size.center(Offset.zero);
    final paint = Paint();

    for (final particle in particles) {
      final distance = particle.speed * seconds * (1 - t * 0.5);
      final position = center +
          Offset(math.cos(particle.angle), math.sin(particle.angle)) * distance +
          Offset(0, _gravity * seconds * seconds / 2);
      paint.color = particle.color.withValues(alpha: 1 - t);
      canvas.drawCircle(position, particle.radius * (1 - t * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => false;
}

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

class AmbientParticles extends StatefulWidget {
  final int count;

  const AmbientParticles({super.key, this.count = 28});

  @override
  State<AmbientParticles> createState() => _AmbientParticlesState();
}

class _AmbientParticlesState extends State<AmbientParticles> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(seconds: 14))..repeat();
  late final List<_Sparkle> _particles;

  @override
  void initState() {
    super.initState();
    final random = math.Random();
    _particles = List.generate(
      widget.count,
      (_) => _Sparkle(
        x: random.nextDouble(),
        offset: random.nextDouble(),
        speed: 0.5 + random.nextDouble(),
        radius: 1 + random.nextDouble() * 2,
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
    return CustomPaint(painter: _AmbientPainter(_controller, _particles), size: Size.infinite);
  }
}

class _AmbientPainter extends CustomPainter {
  final Animation<double> progress;
  final List<_Sparkle> particles;

  _AmbientPainter(this.progress, this.particles) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in particles) {
      final t = (progress.value * particle.speed + particle.offset) % 1;
      final drift = math.sin((t + particle.offset) * math.pi * 4) * 12;
      final position = Offset(particle.x * size.width + drift, (1 - t) * size.height);
      paint.color = Colors.white.withValues(alpha: math.sin(t * math.pi) * 0.35);
      canvas.drawCircle(position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_AmbientPainter oldDelegate) => false;
}
