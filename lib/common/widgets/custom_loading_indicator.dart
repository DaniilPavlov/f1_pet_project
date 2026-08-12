import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Брендовый индикатор загрузки: вращающиеся дуги.
///
/// Рисует [CustomPainter]; вращение — явный [AnimationController].
class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({
    this.size = 100,
    super.key,
  });

  final double size;

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

/// Состояние бесконечного вращения индикатора.
class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: _BrandLoaderPainter(
                t: _controller.value,
                primary: AppTheme.red,
                secondary: context.colors.black,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Две дуги и клетчатый акцент, вращающиеся в разные стороны.
class _BrandLoaderPainter extends CustomPainter {
  _BrandLoaderPainter({
    required this.t,
    required this.primary,
    required this.secondary,
  });

  final double t;
  final Color primary;
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final outerAngle = t * math.pi * 2;
    final innerAngle = -t * math.pi * 2 * 1.35;

    // Внешняя красная дуга + внутренняя тёмная.
    canvas
      ..drawArc(
        rect,
        outerAngle,
        math.pi * 1.2,
        false,
        Paint()
          ..color = primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      )
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius - 10),
        innerAngle,
        math.pi * 0.9,
        false,
        Paint()
          ..color = secondary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.round,
      );

    // Клетчатые сегменты по окружности (сдвиг вместе с t).
    const segments = 16;
    final tickR = radius - 22;
    for (var i = 0; i < segments; i++) {
      if (i.isOdd) {
        continue;
      }
      final a = outerAngle + (math.pi * 2) * (i / segments);
      final p1 = Offset(center.dx + (tickR - 3) * math.cos(a), center.dy + (tickR - 3) * math.sin(a));
      final p2 = Offset(center.dx + (tickR + 3) * math.cos(a), center.dy + (tickR + 3) * math.sin(a));
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = primary.withValues(alpha: 0.55)
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round,
      );
    }

    // Центральная точка.
    canvas.drawCircle(center, 4, Paint()..color = primary);
  }

  @override
  bool shouldRepaint(covariant _BrandLoaderPainter oldDelegate) {
    return oldDelegate.t != t ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary;
  }
}
