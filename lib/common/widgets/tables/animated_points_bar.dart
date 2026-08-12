import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Горизонтальная полоска очков с появлением через явный [AnimationController].
///
/// Долю рисует [CustomPainter] относительно [maxValue].
class AnimatedPointsBar extends StatefulWidget {
  const AnimatedPointsBar({
    required this.value,
    required this.maxValue,
    required this.color,
    this.height = 4,
    this.animationDuration = const Duration(milliseconds: 900),
    super.key,
  });

  final double value;
  final double maxValue;
  final Color color;
  final double height;
  final Duration animationDuration;

  @override
  State<AnimatedPointsBar> createState() => _AnimatedPointsBarState();
}

/// Состояние анимации роста полоски очков.
class _AnimatedPointsBarState extends State<AnimatedPointsBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedPointsBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
    if (oldWidget.value != widget.value || oldWidget.maxValue != widget.maxValue) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.maxValue <= 0 ? 0.0 : (widget.value / widget.maxValue).clamp(0.0, 1.0);
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          return CustomPaint(
            painter: _PointsBarPainter(
              progress: target * _progress.value,
              color: widget.color,
              track: AppTheme.pink.withValues(alpha: 0.45),
            ),
          );
        },
      ),
    );
  }
}

/// Фон дорожки и заливка доли очков.
class _PointsBarPainter extends CustomPainter {
  _PointsBarPainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  final double progress;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final r = Radius.circular(size.height / 2);
    final trackRect = RRect.fromRectAndRadius(Offset.zero & size, r);
    canvas.drawRRect(trackRect, Paint()..color = track);

    final w = size.width * progress.clamp(0.0, 1.0);
    if (w <= 0) {
      return;
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, size.height), r),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _PointsBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.track != track;
  }
}
