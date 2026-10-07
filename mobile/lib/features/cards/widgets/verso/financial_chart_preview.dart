import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/state/async_value.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../market/models/financial_history.dart';

class FinancialChartPreview extends StatelessWidget {
  /// `null` = pas encore demandé (affiché comme un chargement).
  final AsyncValue<FinancialHistory>? history;
  final Color rarityColor;

  const FinancialChartPreview({
    super.key,
    required this.history,
    required this.rarityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: rarityColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _content(),
    );
  }

  Widget _content() {
    return switch (history) {
      null || AsyncLoading() => Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: rarityColor,
            ),
          ),
        ),
      // L'échec de l'historique n'empêche pas d'afficher la cotation.
      AsyncError() => const _ChartUnavailable(),
      AsyncData(:final value) when value.points.length < 2 =>
        const _ChartUnavailable(),
      AsyncData(:final value) => Padding(
          padding: const EdgeInsets.all(8),
          child: CustomPaint(
            painter: _FinancialChartPainter(
              points: value.points,
              color: AppColors.trend(
                value.points.last.price >= value.points.first.price,
              ),
            ),
            child: const SizedBox.expand(),
          ),
        ),
    };
  }
}

class _ChartUnavailable extends StatelessWidget {
  const _ChartUnavailable();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.show_chart_rounded, size: 18, color: AppColors.iconMuted),
          SizedBox(height: 4),
          Text(
            'Price history unavailable',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancialChartPainter extends CustomPainter {
  static const _hPadding = 3.0;
  static const _vPadding = 5.0;

  final List<FinancialHistoryPoint> points;
  final Color color;

  const _FinancialChartPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final chartWidth = size.width - _hPadding * 2;
    final chartHeight = size.height - _vPadding * 2;
    if (chartWidth <= 0 || chartHeight <= 0) return;

    final prices = points.map((p) => p.price).toList();
    final minPrice = prices.reduce(math.min);
    final maxPrice = prices.reduce(math.max);
    final range = maxPrice == minPrice ? 1.0 : maxPrice - minPrice;

    Offset toOffset(int i) => Offset(
          _hPadding + (i / (points.length - 1)) * chartWidth,
          _vPadding + chartHeight * (1 - (prices[i] - minPrice) / range),
        );

    final linePath = Path()..moveTo(toOffset(0).dx, toOffset(0).dy);
    for (var i = 1; i < points.length; i++) {
      final o = toOffset(i);
      linePath.lineTo(o.dx, o.dy);
    }
    final lastOffset = toOffset(points.length - 1);

    // Zone sous la courbe.
    final fillPath = Path.from(linePath)
      ..lineTo(size.width - _hPadding, size.height - _vPadding)
      ..lineTo(_hPadding, size.height - _vPadding)
      ..close();

    canvas
      ..drawPath(
        fillPath,
        Paint()
          ..color = color.withValues(alpha: 0.08)
          ..style = PaintingStyle.fill,
      )
      ..drawPath(
        linePath,
        Paint()
          ..color = color
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke
          ..isAntiAlias = true,
      )
      // Point du dernier prix.
      ..drawCircle(lastOffset, 2.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _FinancialChartPainter oldDelegate) =>
      oldDelegate.points != points || oldDelegate.color != color;
}
