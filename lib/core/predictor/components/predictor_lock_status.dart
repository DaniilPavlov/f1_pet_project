import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Строка статуса lock прогноза: кольцо countdown или иконка замка.
///
/// Кольцо и замок рисует [CustomPainter]; орбита точки — явный [AnimationController].
class PredictorLockStatus extends StatefulWidget {
  const PredictorLockStatus({
    required this.isLocked,
    required this.statusText,
    required this.countdown,
    super.key,
  });

  final bool isLocked;
  final String statusText;
  final CountdownParts countdown;

  @override
  State<PredictorLockStatus> createState() => _PredictorLockStatusState();
}

/// Состояние орбитальной анимации до закрытия прогноза.
class _PredictorLockStatusState extends State<PredictorLockStatus> with SingleTickerProviderStateMixin {
  late final AnimationController _spin;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
    if (!widget.isLocked) {
      _spin.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant PredictorLockStatus oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLocked && _spin.isAnimating) {
      _spin
        ..stop()
        ..value = 0;
    } else if (!widget.isLocked && !_spin.isAnimating) {
      _spin.repeat();
    }
  }

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isLocked ? AppTheme.pink.withValues(alpha: 0.35) : context.colors.grayBG;
    // Доля оставшегося окна (7 суток): полное кольцо далеко от lock, пустое — у порога.
    const windowSeconds = 7 * 24 * 3600;
    final remaining = widget.countdown.totalSeconds.clamp(0, windowSeconds);
    final progress = widget.isLocked ? 0.0 : remaining / windowSeconds;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppTheme.defaultBorderRadius,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: AnimatedBuilder(
              animation: _spin,
              builder: (context, _) {
                return CustomPaint(
                  painter: _LockRingPainter(
                    progress: progress,
                    spin: _spin.value,
                    locked: widget.isLocked,
                    accent: AppTheme.red,
                    track: context.colors.strokeGray.withValues(alpha: 0.55),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.statusText,
              style: AppStyles.caption.copyWith(color: context.colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

/// Кольцо прогресса до lock либо пиктограмма закрытого замка.
class _LockRingPainter extends CustomPainter {
  _LockRingPainter({
    required this.progress,
    required this.spin,
    required this.locked,
    required this.accent,
    required this.track,
  });

  final double progress;
  final double spin;
  final bool locked;
  final Color accent;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 2.5;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = -math.pi / 2;

    canvas.drawArc(
      rect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    if (locked) {
      // Закрытый замок.
      final padlock = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: center.translate(0, 2), width: 10, height: 8),
            const Radius.circular(1.5),
          ),
        );
      canvas
        ..drawPath(padlock, Paint()..color = accent)
        ..drawArc(
          Rect.fromCenter(center: center.translate(0, -1), width: 8, height: 8),
          math.pi,
          math.pi,
          false,
          Paint()
            ..color = accent
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round,
        );
      return;
    }

    final sweep = math.pi * 2 * progress.clamp(0.0, 1.0);
    if (sweep > 0.001) {
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      );
    }

    // Точка, бегущая по кольцу.
    final orbitAngle = start + math.pi * 2 * spin;
    final ox = center.dx + radius * math.cos(orbitAngle);
    final oy = center.dy + radius * math.sin(orbitAngle);
    canvas.drawCircle(Offset(ox, oy), 2.4, Paint()..color = accent);
  }

  @override
  bool shouldRepaint(covariant _LockRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.spin != spin ||
        oldDelegate.locked != locked ||
        oldDelegate.accent != accent ||
        oldDelegate.track != track;
  }
}
