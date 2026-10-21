import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

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
