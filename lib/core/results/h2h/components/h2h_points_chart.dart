import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:flutter/material.dart';

/// Линейный график накопленных очков двух участников (CustomPainter).
class H2hPointsChart extends StatelessWidget {
  const H2hPointsChart({
    required this.timeline,
    required this.colorA,
    required this.colorB,
    this.height = 220,
    super.key,
  });

  final H2hPointsTimeline timeline;
  final Color colorA;
  final Color colorB;
  final double height;

  @override
  Widget build(BuildContext context) {
    final axisColor = context.colors.textGray;
    final gridColor = context.colors.strokeGray.withValues(alpha: 0.5);
    final labelStyle = AppStyles.caption.copyWith(color: context.colors.textGray, fontSize: 10);

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _H2hPointsChartPainter(
          timeline: timeline,
          colorA: colorA,
          colorB: colorB,
          axisColor: axisColor,
          gridColor: gridColor,
          labelStyle: labelStyle,
        ),
      ),
    );
  }
}

class _H2hPointsChartPainter extends CustomPainter {
  _H2hPointsChartPainter({
    required this.timeline,
    required this.colorA,
    required this.colorB,
    required this.axisColor,
    required this.gridColor,
    required this.labelStyle,
  });

  final H2hPointsTimeline timeline;
  final Color colorA;
  final Color colorB;
  final Color axisColor;
  final Color gridColor;
  final TextStyle labelStyle;

  static const _leftPad = 36.0;
  static const _rightPad = 8.0;
  static const _topPad = 12.0;
  static const _bottomPad = 28.0;

  @override
  void paint(Canvas canvas, Size size) {
    final points = timeline.points;
    if (points.isEmpty) {
      return;
    }

    final chart = Rect.fromLTRB(_leftPad, _topPad, size.width - _rightPad, size.height - _bottomPad);
    if (chart.width <= 0 || chart.height <= 0) {
      return;
    }

    var maxY = timeline.maxCumulative;
    if (maxY < 1) {
      maxY = 1;
    }
    final niceMax = _niceCeil(maxY);
    final yTicks = 4;

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1;

    for (var i = 0; i <= yTicks; i++) {
      final t = i / yTicks;
      final y = chart.bottom - chart.height * t;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      final value = niceMax * t;
      _drawText(
        canvas,
        _formatPoints(value),
        Offset(0, y - 6),
        labelStyle,
        maxWidth: _leftPad - 4,
        align: TextAlign.right,
      );
    }

    canvas.drawLine(Offset(chart.left, chart.bottom), Offset(chart.right, chart.bottom), axisPaint);

    Offset pointAt(int index, double cumulative) {
      final x = points.length == 1
          ? chart.left + chart.width / 2
          : chart.left + chart.width * (index / (points.length - 1));
      final y = chart.bottom - chart.height * (cumulative / niceMax);
      return Offset(x, y);
    }

    void drawSeries(Color color, double Function(H2hTimelinePoint) valueOf) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final p = pointAt(i, valueOf(points[i]));
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      final dotPaint = Paint()..color = color;
      for (var i = 0; i < points.length; i++) {
        final p = pointAt(i, valueOf(points[i]));
        canvas.drawCircle(p, points.length > 30 ? 1.5 : 3, dotPaint);
      }
    }

    drawSeries(colorA, (p) => p.cumulativeA);
    drawSeries(colorB, (p) => p.cumulativeB);

    final labelStep = _labelStep(points.length);
    for (var i = 0; i < points.length; i += labelStep) {
      final p = pointAt(i, 0);
      _drawText(
        canvas,
        points[i].label,
        Offset(p.dx - 18, chart.bottom + 6),
        labelStyle,
        maxWidth: 40,
        align: TextAlign.center,
      );
    }
  }

  static int _labelStep(int count) {
    if (count <= 8) {
      return 1;
    }
    if (count <= 16) {
      return 2;
    }
    if (count <= 30) {
      return 3;
    }
    return math.max(1, count ~/ 8);
  }

  static double _niceCeil(double value) {
    if (value <= 0) {
      return 1;
    }
    final exp = (math.log(value) / math.ln10).floor();
    final pow10 = math.pow(10, exp).toDouble();
    final fraction = value / pow10;
    final nice = fraction <= 1
        ? 1.0
        : fraction <= 2
        ? 2.0
        : fraction <= 5
        ? 5.0
        : 10.0;
    return nice * pow10;
  }

  static String _formatPoints(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  static void _drawText(
    Canvas canvas,
    String text,
    Offset offset,
    TextStyle style, {
    required double maxWidth,
    TextAlign align = TextAlign.left,
  }) {
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: align, maxLines: 1))
      ..pushStyle(
        ui.TextStyle(
          color: style.color,
          fontSize: style.fontSize,
          fontFamily: style.fontFamily,
        ),
      )
      ..addText(text);
    final paragraph = builder.build()..layout(ui.ParagraphConstraints(width: maxWidth));
    canvas.drawParagraph(paragraph, offset);
  }

  @override
  bool shouldRepaint(covariant _H2hPointsChartPainter oldDelegate) {
    return oldDelegate.timeline != timeline ||
        oldDelegate.colorA != colorA ||
        oldDelegate.colorB != colorB ||
        oldDelegate.axisColor != axisColor ||
        oldDelegate.gridColor != gridColor;
  }
}

/// Легенда и итог очков под графиком.
class H2hPointsChartLegend extends StatelessWidget {
  const H2hPointsChartLegend({
    required this.nameA,
    required this.nameB,
    required this.pointsA,
    required this.pointsB,
    required this.colorA,
    required this.colorB,
    super.key,
  });

  final String nameA;
  final String nameB;
  final double pointsA;
  final double pointsB;
  final Color colorA;
  final Color colorB;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _LegendItem(name: nameA, points: pointsA, color: colorA)),
        const SizedBox(width: 12),
        Expanded(child: _LegendItem(name: nameB, points: pointsB, color: colorB)),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.name, required this.points, required this.color});

  final String name;
  final double points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final pts = points == points.roundToDouble() ? points.toInt().toString() : points.toStringAsFixed(1);
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            style: AppStyles.caption.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          pts,
          style: AppStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            color: color == AppTheme.red ? AppTheme.red : null,
          ),
        ),
      ],
    );
  }
}
