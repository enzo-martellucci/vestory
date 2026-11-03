import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/invest/domain/simulation.dart';
import 'package:mobile/features/invest/presentation/money_format.dart';

class SimulationChart extends StatelessWidget {
  final SimulationResult result;

  const SimulationChart({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final points = result.points;
    final valueColor = AppColors.trend(result.gain >= 0);

    return Column(
      crossAxisAlignment: .stretch,
      spacing: 12,
      children: [
        SizedBox(
          height: 220,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, progress, _) => CustomPaint(
              painter: _ChartPainter(points: points, valueColor: valueColor, progress: progress),
            ),
          ),
        ),
        Row(
          children: [
            Text('${points.first.date.year}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            const Spacer(),
            Text('${points.last.date.year}', style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ],
        ),
        Wrap(
          spacing: 16,
          runSpacing: 6,
          children: [
            _Legend(color: valueColor, label: 'Your investment'),
            const _Legend(color: AppColors.muted, label: 'Money put in', dashed: true),
            const _Legend(color: AppColors.legendary, label: 'Savings account (3 %)'),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final bool dashed;

  const _Legend({required this.color, required this.label, this.dashed = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      spacing: 6,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: dashed ? null : color,
            borderRadius: BorderRadius.circular(2),
            border: dashed ? Border(top: BorderSide(color: color, width: 2)) : null,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textBody)),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<SimulationPoint> points;
  final Color valueColor;
  final double progress;

  _ChartPainter({required this.points, required this.valueColor, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final values = points.expand((point) => [point.value, point.invested, point.savingsValue]);
    final maxValue = values.reduce(math.max) * 1.08;
    final minValue = math.min(0.0, values.reduce(math.min));
    final visibleCount = math.max(2, (points.length * progress).ceil());

    Offset position(int index, double value) => Offset(
      index / (points.length - 1) * size.width,
      size.height - (value - minValue) / (maxValue - minValue) * size.height,
    );

    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var line = 0; line <= 3; line++) {
      final y = size.height * line / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    _drawLabel(canvas, formatEuros(maxValue), const Offset(0, 2));

    Path pathOf(double Function(SimulationPoint point) select) {
      final path = Path()..moveTo(0, position(0, select(points.first)).dy);
      for (var index = 1; index < visibleCount; index++)
        path.lineTo(position(index, select(points[index])).dx, position(index, select(points[index])).dy);
      return path;
    }

    final valuePath = pathOf((point) => point.value);
    final lastX = position(visibleCount - 1, 0).dx;
    final areaPath = Path.from(valuePath)
      ..lineTo(lastX, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      areaPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [valueColor.withValues(alpha: 0.28), valueColor.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      pathOf((point) => point.savingsValue),
      Paint()
        ..color = AppColors.legendary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawDashed(
      canvas,
      pathOf((point) => point.invested),
      Paint()
        ..color = AppColors.muted
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawPath(
      valuePath,
      Paint()
        ..color = valueColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeJoin = StrokeJoin.round,
    );

    final last = position(visibleCount - 1, points[visibleCount - 1].value);
    canvas.drawCircle(last, 6, Paint()..color = Colors.white);
    canvas.drawCircle(last, 4, Paint()..color = valueColor);
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 6), paint);
        distance += 11;
      }
    }
  }

  void _drawLabel(Canvas canvas, String text, Offset offset) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(_ChartPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.points != points || oldDelegate.valueColor != valueColor;
}
