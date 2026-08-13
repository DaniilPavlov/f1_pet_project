import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:flutter/material.dart';

/// Линейный график накопленных очков двух участников.
///
/// Линии рисует [CustomPainter]; появление — явный [AnimationController].
class H2hPointsChart extends StatefulWidget {
  const H2hPointsChart({
    required this.timeline,
    required this.colorA,
    required this.colorB,
    this.height = 220,
    this.animationDuration = const Duration(milliseconds: 1400),
    super.key,
  });

  final H2hPointsTimeline timeline;
  final Color colorA;
  final Color colorB;
  final double height;
  final Duration animationDuration;

  @override
  State<H2hPointsChart> createState() => _H2hPointsChartState();
}

/// Состояние анимации появления линий графика.
class _H2hPointsChartState extends State<H2hPointsChart> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    if (widget.timeline.points.isNotEmpty) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant H2hPointsChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
    if (oldWidget.timeline != widget.timeline) {
      if (widget.timeline.points.isEmpty) {
        _controller.value = 0;
      } else {
        _controller.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final axisColor = context.colors.textGray;
    final gridColor = context.colors.strokeGray.withValues(alpha: 0.5);
    final labelStyle = AppStyles.caption.copyWith(color: context.colors.textGray, fontSize: 10);

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          return CustomPaint(
            painter: _H2hPointsChartPainter(
              timeline: widget.timeline,
              colorA: widget.colorA,
              colorB: widget.colorB,
              axisColor: axisColor,
              gridColor: gridColor,
              labelStyle: labelStyle,
              progress: _progress.value,
            ),
          );
        },
      ),
    );
  }
}

/// Отрисовка осей, сеток и двух серий с прогрессом [progress] (`0…1`).
class _H2hPointsChartPainter extends CustomPainter {
  _H2hPointsChartPainter({
    required this.timeline,
    required this.colorA,
    required this.colorB,
    required this.axisColor,
    required this.gridColor,
    required this.labelStyle,
    required this.progress,
  });

  final H2hPointsTimeline timeline;
  final Color colorA;
  final Color colorB;
  final Color axisColor;
  final Color gridColor;
  final TextStyle labelStyle;
  final double progress;

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

      final metrics = path.computeMetrics().toList();
      final metric = metrics.isEmpty ? null : metrics.first;
      final drawProgress = progress.clamp(0.0, 1.0);
      final Path visiblePath;
      ui.Tangent? tip;
      if (metric == null || metric.length <= 0) {
        visiblePath = drawProgress > 0 ? path : Path();
        if (points.isNotEmpty && drawProgress > 0) {
          tip = ui.Tangent(pointAt(0, valueOf(points[0])), const Offset(1, 0));
        }
      } else {
        visiblePath = metric.extractPath(0, metric.length * drawProgress);
        tip = metric.getTangentForOffset(metric.length * drawProgress);
      }

      if (tip != null && drawProgress > 0) {
        final first = pointAt(0, valueOf(points[0]));
        final fillPath = Path.from(visiblePath)
          ..lineTo(tip.position.dx, chart.bottom)
          ..lineTo(first.dx, chart.bottom)
          ..close();
        canvas.drawPath(
          fillPath,
          Paint()
            ..shader = ui.Gradient.linear(
              Offset(chart.left, chart.top),
              Offset(chart.left, chart.bottom),
              [
                color.withValues(alpha: 0.22 * drawProgress),
                color.withValues(alpha: 0.02),
              ],
            ),
        );
      }

      canvas.drawPath(
        visiblePath,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );

      if (tip != null && drawProgress > 0) {
        canvas
          ..drawCircle(
            tip.position,
            5,
            Paint()..color = color.withValues(alpha: 0.35),
          )
          ..drawCircle(tip.position, 3, Paint()..color = color);
      }

      final dotPaint = Paint()..color = color;
      final dotRadius = points.length > 30 ? 1.5 : 3.0;
      for (var i = 0; i < points.length; i++) {
        final t = points.length == 1 ? 1.0 : i / (points.length - 1);
        if (t > drawProgress + 0.001) {
          break;
        }
        canvas.drawCircle(pointAt(i, valueOf(points[i])), dotRadius, dotPaint);
      }
    }

    drawSeries(colorA, (p) => p.cumulativeA);
    drawSeries(colorB, (p) => p.cumulativeB);

    if (progress > 0.02 && points.length > 1) {
      final scrubX = chart.left + chart.width * progress.clamp(0.0, 1.0);
      canvas.drawLine(
        Offset(scrubX, chart.top),
        Offset(scrubX, chart.bottom),
        Paint()
          ..color = axisColor.withValues(alpha: 0.35)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke,
      );
    }

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
        oldDelegate.gridColor != gridColor ||
        oldDelegate.progress != progress;
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
    final aLeads = pointsA > pointsB;
    final bLeads = pointsB > pointsA;
    return Row(
      children: [
        Expanded(
          child: _LegendItem(
            name: nameA,
            points: pointsA,
            color: colorA,
            highlightPoints: aLeads,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _LegendItem(
            name: nameB,
            points: pointsB,
            color: colorB,
            highlightPoints: bLeads,
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.name,
    required this.points,
    required this.color,
    required this.highlightPoints,
  });

  final String name;
  final double points;
  final Color color;
  final bool highlightPoints;

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
            color: highlightPoints ? AppTheme.red : context.colors.black,
          ),
        ),
      ],
    );
  }
}
