import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:mobile/core/theme/app_colors.dart';

class LineChart extends StatelessWidget {
  final List<double> values;
  final Color color;
  final double? baseline;
  final double height;

  const LineChart({super.key, required this.values, required this.color, this.baseline, this.height = 160});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOutCubic,
        builder: (context, progress, _) => CustomPaint(
          painter: _LineChartPainter(values: values, color: color, baseline: baseline, progress: progress),
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final double? baseline;
  final double progress;

  _LineChartPainter({required this.values, required this.color, required this.baseline, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2)
      return;

    final all = [...values, ?baseline];
    final minValue = all.reduce(min);
    final maxValue = all.reduce(max);
    final range = maxValue - minValue == 0 ? 1 : maxValue - minValue;
    const verticalPadding = 8.0;
    final chartHeight = size.height - verticalPadding * 2;

    Offset pointAt(int index, double value) => Offset(
      size.width * index / (values.length - 1),
      verticalPadding + chartHeight * (1 - (value - minValue) / range),
    );

    if (baseline != null) {
      final y = pointAt(0, baseline!).dy;
      final dash = Paint()
        ..color = AppColors.muted.withValues(alpha: 0.4)
        ..strokeWidth = 1;
      for (var x = 0.0; x < size.width; x += 8)
        canvas.drawLine(Offset(x, y), Offset(min(x + 4, size.width), y), dash);
    }

    final visibleCount = max(2, (values.length * progress).ceil());
    final line = Path();
    for (var index = 0; index < visibleCount; index++) {
      final point = pointAt(index, values[index]);
      if (index == 0)
        line.moveTo(point.dx, point.dy);
      else
        line.lineTo(point.dx, point.dy);
    }

    final last = pointAt(visibleCount - 1, values[visibleCount - 1]);
    final area = Path.from(line)
      ..lineTo(last.dx, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(last, 4.5, Paint()..color = color);
    canvas.drawCircle(last, 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.progress != progress || oldDelegate.color != color;
}
