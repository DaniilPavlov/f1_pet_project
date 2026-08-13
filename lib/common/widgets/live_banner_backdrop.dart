import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Анимированный фон live-баннера: пульс индикатора, блик и клетчатая полоса.
class LiveBannerBackdrop extends StatefulWidget {
  const LiveBannerBackdrop({required this.child, super.key});

  final Widget child;

  @override
  State<LiveBannerBackdrop> createState() => _LiveBannerBackdropState();
}

/// Состояние явного [AnimationController] для бесшовного цикла фона.
class _LiveBannerBackdropState extends State<LiveBannerBackdrop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _LiveBannerPainter(t: _controller.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Отрисовка фона: красная заливка, блик слева→направо, пунктир вправо, LED.
class _LiveBannerPainter extends CustomPainter {
  _LiveBannerPainter({required this.t});

  /// Прогресс цикла анимации в диапазоне `0…1`.
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = AppTheme.red);

    // Мягкий блик: едет вправо, цикл без скачка на стыке.
    final bandW = size.width * 0.32;
    final travel = size.width + bandW;
    final sweepX = -bandW + (t * travel) % travel;
    final bandRect = Rect.fromLTWH(sweepX, 0, bandW, size.height);
    canvas.drawRect(
      bandRect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            AppTheme.onChrome.withValues(alpha: 0),
            AppTheme.onChrome.withValues(alpha: 0.12),
            AppTheme.onChrome.withValues(alpha: 0),
          ],
        ).createShader(bandRect),
    );

    // Клетчатая полоса снизу: сдвиг вправо, период бесшовный.
    const cellW = 7.0;
    const cellH = 4.0;
    final period = cellW * 2;
    final dx = (t * period) % period;
    final stripTop = size.height - cellH;
    final dashPaint = Paint()..color = AppTheme.onChrome.withValues(alpha: 0.28);

    canvas
      ..save()
      ..clipRect(Rect.fromLTWH(0, stripTop, size.width, cellH));
    for (var i = -2; i * cellW < size.width + period * 2; i++) {
      if (i.isEven) {
        canvas.drawRect(
          Rect.fromLTWH(i * cellW + dx, stripTop, cellW, cellH),
          dashPaint,
        );
      }
    }
    canvas.restore();

    // Пульсирующий индикатор слева.
    final pulse = (math.sin(t * math.pi * 2) + 1) / 2;
    final led = Offset(14, size.height / 2);
    canvas
      ..drawCircle(
        led,
        7 + pulse * 3,
        Paint()..color = AppTheme.onChrome.withValues(alpha: 0.18 + 0.2 * pulse),
      )
      ..drawCircle(led, 4, Paint()..color = AppTheme.onChrome)
      ..drawCircle(
        led,
        4,
        Paint()
          ..color = AppTheme.red.withValues(alpha: 0.35)
          ..blendMode = BlendMode.multiply,
      );
  }

  @override
  bool shouldRepaint(covariant _LiveBannerPainter oldDelegate) => oldDelegate.t != t;
}
