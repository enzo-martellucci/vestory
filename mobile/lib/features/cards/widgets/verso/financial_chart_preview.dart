import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../market/models/financial_history.dart';

class FinancialChartPreview extends StatelessWidget {
  final List<FinancialHistoryPoint> points;
  final bool loading;
  final Object? error;
  final Color rarityColor;

  const FinancialChartPreview({
    super.key,
    required this.points,
    required this.loading,
    required this.error,
    required this.rarityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: rarityColor.withValues(
          alpha: 0.05,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    // History is loading:
    // only the chart area shows a loader.
    if (loading) {
      return Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            color: rarityColor,
          ),
        ),
      );
    }

    // History failed:
    // the rest of the financial data remains available.
    if (error != null) {
      return const _ChartUnavailable();
    }

    // Not enough points to draw a chart.
    if (points.length < 2) {
      return const _ChartUnavailable();
    }

    final firstPrice = points.first.price;
    final lastPrice = points.last.price;

    final isPositive =
        lastPrice >= firstPrice;

    final lineColor =
    isPositive
        ? const Color(0xFF159B61)
        : const Color(0xFFD94B4B);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: CustomPaint(
        painter: _FinancialChartPainter(
          points: points,
          color: lineColor,
        ),
        child: const SizedBox.expand(),
      ),
    );
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
          Icon(
            Icons.show_chart_rounded,
            size: 18,
            color: Color(0xFFB0B0B0),
          ),
          SizedBox(height: 4),
          Text(
            'Price history unavailable',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF999999),
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
  final List<FinancialHistoryPoint> points;
  final Color color;

  const _FinancialChartPainter({
    required this.points,
    required this.color,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {
    if (points.length < 2) {
      return;
    }

    final prices =
    points
        .map(
          (point) => point.price,
    )
        .toList();

    final minPrice =
    prices.reduce(math.min);

    final maxPrice =
    prices.reduce(math.max);

    var range =
        maxPrice - minPrice;

    if (range == 0) {
      range = 1;
    }

    const horizontalPadding = 3.0;
    const verticalPadding = 5.0;

    final chartWidth =
        size.width -
            horizontalPadding * 2;

    final chartHeight =
        size.height -
            verticalPadding * 2;

    if (chartWidth <= 0 ||
        chartHeight <= 0) {
      return;
    }

    final linePath = Path();

    Offset? lastOffset;

    for (
    var i = 0;
    i < points.length;
    i++
    ) {
      final progress =
          i /
              (points.length - 1);

      final x =
          horizontalPadding +
              progress * chartWidth;

      final normalizedPrice =
          (points[i].price -
              minPrice) /
              range;

      final y =
          verticalPadding +
              chartHeight *
                  (1 - normalizedPrice);

      final offset =
      Offset(x, y);

      if (i == 0) {
        linePath.moveTo(
          offset.dx,
          offset.dy,
        );
      } else {
        linePath.lineTo(
          offset.dx,
          offset.dy,
        );
      }

      lastOffset = offset;
    }

    // Area below the line.
    final fillPath =
    Path.from(linePath)
      ..lineTo(
        size.width -
            horizontalPadding,
        size.height -
            verticalPadding,
      )
      ..lineTo(
        horizontalPadding,
        size.height -
            verticalPadding,
      )
      ..close();

    final fillPaint =
    Paint()
      ..color =
      color.withValues(
        alpha: 0.08,
      )
      ..style =
          PaintingStyle.fill;

    canvas.drawPath(
      fillPath,
      fillPaint,
    );

    // Price line.
    final linePaint =
    Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap =
          StrokeCap.round
      ..strokeJoin =
          StrokeJoin.round
      ..style =
          PaintingStyle.stroke
      ..isAntiAlias = true;

    canvas.drawPath(
      linePath,
      linePaint,
    );

    // Current price point.
    if (lastOffset != null) {
      final pointPaint =
      Paint()
        ..color = color
        ..style =
            PaintingStyle.fill;

      canvas.drawCircle(
        lastOffset,
        2.5,
        pointPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant _FinancialChartPainter oldDelegate,
      ) {
    return oldDelegate.points != points ||
        oldDelegate.color != color;
  }
}