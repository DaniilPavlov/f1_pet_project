import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Короткий success-snap после успешного входа / регистрации.
///
/// Галочка и кольцо — [CustomPainter]; появление — явный [AnimationController].
class AuthSuccessSnap extends StatefulWidget {
  const AuthSuccessSnap({
    this.size = 88,
    this.duration = const Duration(milliseconds: 700),
    super.key,
  });

  final double size;
  final Duration duration;

  @override
  State<AuthSuccessSnap> createState() => _AuthSuccessSnapState();
}

/// Состояние одноразовой анимации успеха.
class _AuthSuccessSnapState extends State<AuthSuccessSnap> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _t;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _t = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
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
          animation: _t,
          builder: (context, _) {
            return CustomPaint(
              painter: _AuthSuccessPainter(t: _t.value),
            );
          },
        ),
      ),
    );
  }
}

/// Кольцо + галочка, рисуются по прогрессу `t`.
class _AuthSuccessPainter extends CustomPainter {
  _AuthSuccessPainter({required this.t});

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 4;
    final ringT = (t / 0.45).clamp(0.0, 1.0);
    final checkT = ((t - 0.35) / 0.55).clamp(0.0, 1.0);

    canvas
      ..drawCircle(
        center,
        radius,
        Paint()
          ..color = AppTheme.red.withValues(alpha: 0.12 * ringT)
          ..style = PaintingStyle.fill,
      )
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        math.pi * 2 * ringT,
        false,
        Paint()
          ..color = AppTheme.red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..isAntiAlias = true,
      );

    if (checkT <= 0) {
      return;
    }

    final path = Path()
      ..moveTo(center.dx - radius * 0.35, center.dy)
      ..lineTo(center.dx - radius * 0.08, center.dy + radius * 0.28)
      ..lineTo(center.dx + radius * 0.4, center.dy - radius * 0.32);

    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) {
      return;
    }
    final metric = metrics.first;
    final extract = metric.extractPath(0, metric.length * checkT);
    canvas.drawPath(
      extract,
      Paint()
        ..color = AppTheme.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant _AuthSuccessPainter oldDelegate) => oldDelegate.t != t;
}
