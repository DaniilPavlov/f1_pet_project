import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Брендовый индикатор загрузки: вращающиеся дуги.
///
/// Рисует [CustomPainter] каждый кадр через [AnimationController] —
/// дуги остаются геометрически ровными (без ряби от rotate bitmap-слоя).
class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({
    this.size = 112,
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

/// Дуги + солнышко; геометрия пропорциональна [Size].
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
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final minSide = math.min(size.width, size.height);

    final outerStroke = (minSide * 0.075).clamp(1.5, 8.0);
    final innerStroke = (minSide * 0.05).clamp(1.2, 6.0);
    final inset = minSide * 0.10;
    final outerRadius = minSide / 2 - inset;
    // Красная↔чёрная чуть плотнее.
    final gap = outerStroke / 2 + innerStroke / 2 + minSide * 0.09;
    final innerRadius = (outerRadius - gap).clamp(minSide * 0.12, outerRadius);

    final outerAngle = outerT * math.pi * 2;
    final innerAngle = -innerT * math.pi * 2;

    canvas
      ..drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        outerAngle,
        math.pi * 1.25,
        false,
        _stroke(primary, outerStroke),
      )
      ..drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        innerAngle,
        math.pi * 0.95,
        false,
        _stroke(secondary, innerStroke),
      );

    // Солнышко всегда: на мини — чуть толще лучи, чтобы не пропадали.
    final tickRadius = innerRadius * 0.30;
    final tickLen = (minSide * 0.022).clamp(1.5, 4.0);
    final tickWidth = (minSide * 0.022).clamp(1.4, 3.0);
    final hubRadius = (minSide * 0.045).clamp(1.5, 6.0);
    final tickPaint = _stroke(primary.withValues(alpha: 0.55), tickWidth);

    const segments = 16;
    for (var i = 0; i < segments; i++) {
      if (i.isOdd) {
        continue;
      }
      final a = outerAngle + (math.pi * 2) * (i / segments);
      final p1 = Offset(
        center.dx + (tickRadius - tickLen) * math.cos(a),
        center.dy + (tickRadius - tickLen) * math.sin(a),
      );
      final p2 = Offset(
        center.dx + (tickRadius + tickLen) * math.cos(a),
        center.dy + (tickRadius + tickLen) * math.sin(a),
      );
      canvas.drawLine(p1, p2, tickPaint);
    }

    canvas.drawCircle(
      center,
      hubRadius,
      Paint()
        ..color = primary
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant _BrandLoaderPainter oldDelegate) {
    return oldDelegate.outerT != outerT ||
        oldDelegate.innerT != innerT ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary;
  }
}
