import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Панель countdown до гонки: дни / часы / минуты с кольцами прогресса.
///
/// Кольца рисует [CustomPainter], пульс — явный [AnimationController].
class ScheduleCountdownPanel extends StatefulWidget {
  const ScheduleCountdownPanel({
    required this.countdown,
    required this.daysLabel,
    required this.hoursLabel,
    required this.minutesLabel,
    super.key,
  });

  final CountdownParts countdown;
  final String daysLabel;
  final String hoursLabel;
  final String minutesLabel;

  @override
  State<ScheduleCountdownPanel> createState() => _ScheduleCountdownPanelState();
}

/// Состояние пульсации колец countdown.
class _ScheduleCountdownPanelState extends State<ScheduleCountdownPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.countdown;
    final axis = context.colors.strokeGray.withValues(alpha: 0.55);
    final labelColor = context.colors.textGray;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final pulse = Curves.easeInOut.transform(_pulse.value);
        return Row(
          children: [
            Expanded(
              child: _RingCell(
                value: '${c.days}',
                label: widget.daysLabel,
                progress: (c.days / 14).clamp(0.0, 1.0),
                pulse: pulse,
                accent: AppTheme.red,
                track: axis,
                labelColor: labelColor,
              ),
            ),
            Expanded(
              child: _RingCell(
                value: c.hours.toString().padLeft(2, '0'),
                label: widget.hoursLabel,
                progress: c.hours / 24,
                pulse: pulse,
                accent: AppTheme.red,
                track: axis,
                labelColor: labelColor,
              ),
            ),
            Expanded(
              child: _RingCell(
                value: c.minutes.toString().padLeft(2, '0'),
                label: widget.minutesLabel,
                progress: c.minutes / 60,
                pulse: pulse,
                accent: AppTheme.red,
                track: axis,
                labelColor: labelColor,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Одна ячейка: цифра по центру кольца и подпись снизу.
class _RingCell extends StatelessWidget {
  const _RingCell({
    required this.value,
    required this.label,
    required this.progress,
    required this.pulse,
    required this.accent,
    required this.track,
    required this.labelColor,
  });

  final String value;
  final String label;
  final double progress;
  final double pulse;
  final Color accent;
  final Color track;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 72,
          width: 72,
          child: CustomPaint(
            painter: _CountdownRingPainter(
              progress: progress,
              pulse: pulse,
              accent: accent,
              track: track,
            ),
            child: Center(
              child: Text(value, style: AppStyles.h3),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppStyles.caption.copyWith(color: labelColor)),
      ],
    );
  }
}

/// Кольцо прогресса с пульсом толщины и подсветкой кончика.
class _CountdownRingPainter extends CustomPainter {
  _CountdownRingPainter({
    required this.progress,
    required this.pulse,
    required this.accent,
    required this.track,
  });

  final double progress;
  final double pulse;
  final Color accent;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 5;
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
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    final sweep = (math.pi * 2) * progress.clamp(0.0, 1.0);
    if (sweep > 0.001) {
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = accent.withValues(alpha: 0.85 + 0.15 * pulse)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5 + pulse
          ..strokeCap = StrokeCap.round,
      );

      // Свечение на конце дуги.
      final tipAngle = start + sweep;
      final tip = Offset(
        center.dx + radius * math.cos(tipAngle),
        center.dy + radius * math.sin(tipAngle),
      );
      canvas
        ..drawCircle(
          tip,
          3.5 + pulse,
          Paint()..color = accent.withValues(alpha: 0.35 + 0.25 * pulse),
        )
        ..drawCircle(tip, 2, Paint()..color = accent);
    }

    // Короткие риски внутри кольца.
    final tickPaint = Paint()
      ..color = accent.withValues(alpha: 0.18 + 0.1 * pulse)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 12; i++) {
      final a = start + (math.pi * 2) * (i / 12);
      final inner = radius - 7;
      final outer = radius - 3;
      canvas.drawLine(
        Offset(center.dx + inner * math.cos(a), center.dy + inner * math.sin(a)),
        Offset(center.dx + outer * math.cos(a), center.dy + outer * math.sin(a)),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CountdownRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulse != pulse ||
        oldDelegate.accent != accent ||
        oldDelegate.track != track;
  }
}
