import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Брендовый индикатор загрузки: вращающиеся дуги.
///
/// Типовой лоадер приложения (не для pull-to-refresh).
/// Рисует [CustomPainter]; вращение — два явных [AnimationController].
class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({
    this.size = 100,
    this.onDarkBackground = false,
    super.key,
  });

  final double size;

  /// На тёмном фоне (кнопка): внутренняя дуга светлая, иначе чёрная.
  final bool onDarkBackground;

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

/// Состояние бесконечного вращения индикатора.
class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _outer;
  late final AnimationController _inner;

  @override
  void initState() {
    super.initState();
    _outer = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat();
    _inner = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat();
  }

  @override
  void dispose() {
    _outer.dispose();
    _inner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondary = widget.onDarkBackground ? AppTheme.onChrome : context.colors.black;
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: Listenable.merge([_outer, _inner]),
          builder: (context, _) {
            return CustomPaint(
              isComplex: true,
              willChange: true,
              painter: _BrandLoaderPainter(
                outerT: _outer.value,
                innerT: _inner.value,
                primary: AppTheme.red,
                secondary: secondary,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Дуги и штрихи; геометрия пропорциональна [Size], циклы без скачка.
class _BrandLoaderPainter extends CustomPainter {
  _BrandLoaderPainter({
    required this.outerT,
    required this.innerT,
    required this.primary,
    required this.secondary,
  });

  final double outerT;
  final double innerT;
  final Color primary;
  final Color secondary;

  Paint _stroke(Color color, double width) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.high;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const scale = 2.0;
    canvas
      ..save()
      ..scale(1 / scale, 1 / scale);

    final w = size.width * scale;
    final h = size.height * scale;
    final center = Offset(w / 2, h / 2);
    final minSide = math.min(w, h);
    final inset = minSide * 0.08;
    final radius = minSide / 2 - inset;

    final outerStroke = math.max(2, minSide * 0.07).toDouble();
    final innerStroke = math.max(1.5, minSide * 0.05);
    final gap = math.max(outerStroke * 1.6, minSide * 0.1);
    final innerRadius = math.max(minSide * 0.12, radius - gap);

    final outerAngle = outerT * math.pi * 2;
    final innerAngle = -innerT * math.pi * 2;

    canvas
      ..drawPath(
        Path()..addArc(Rect.fromCircle(center: center, radius: radius), outerAngle, math.pi * 1.25),
        _stroke(primary, outerStroke),
      )
      ..drawPath(
        Path()..addArc(Rect.fromCircle(center: center, radius: innerRadius), innerAngle, math.pi * 0.95),
        _stroke(secondary, innerStroke),
      );

    const segments = 16;
    final tickR = innerRadius * 0.55;
    final tickLen = math.max(2, minSide * 0.04).toDouble();
    final tickPaint = _stroke(primary.withValues(alpha: 0.55), math.max(1.2, minSide * 0.025));
    for (var i = 0; i < segments; i++) {
      if (i.isOdd) {
        continue;
      }
      final a = outerAngle + (math.pi * 2) * (i / segments);
      final p1 = Offset(center.dx + (tickR - tickLen) * math.cos(a), center.dy + (tickR - tickLen) * math.sin(a));
      final p2 = Offset(center.dx + (tickR + tickLen) * math.cos(a), center.dy + (tickR + tickLen) * math.sin(a));
      canvas.drawLine(p1, p2, tickPaint);
    }

    canvas
      ..drawCircle(
        center,
        math.max(2, minSide * 0.055).toDouble(),
        Paint()
          ..color = primary
          ..isAntiAlias = true
          ..filterQuality = FilterQuality.high,
      )
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _BrandLoaderPainter oldDelegate) {
    return oldDelegate.outerT != outerT ||
        oldDelegate.innerT != innerT ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary;
  }
}
