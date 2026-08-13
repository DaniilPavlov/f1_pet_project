import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_comparison_tile.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_comparison.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';

/// Анимированное раскрытие сравнения предикта: счётчик очков + строки по очереди.
///
/// Прогресс ведёт явный [AnimationController]; акцент строки — [CustomPainter].
class PredictorSessionReveal extends StatefulWidget {
  const PredictorSessionReveal({
    required this.rows,
    required this.points,
    required this.pointsLabelBuilder,
    required this.driversById,
    required this.predictedLabel,
    required this.actualLabel,
    this.animationDuration = const Duration(milliseconds: 1200),
    super.key,
  });

  final List<PredictorComparisonRow> rows;
  final int points;

  /// Подпись очков по текущему (анимированному) значению.
  final String Function(int points) pointsLabelBuilder;
  final Map<String, DriverModel> driversById;
  final String predictedLabel;
  final String actualLabel;
  final Duration animationDuration;

  @override
  State<PredictorSessionReveal> createState() => _PredictorSessionRevealState();
}

/// Состояние анимации появления сравнения.
class _PredictorSessionRevealState extends State<PredictorSessionReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    if (widget.rows.isNotEmpty) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant PredictorSessionReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
    final rowsChanged = oldWidget.rows.length != widget.rows.length ||
        !_sameRows(oldWidget.rows, widget.rows) ||
        oldWidget.points != widget.points;
    if (rowsChanged) {
      if (widget.rows.isEmpty) {
        _controller.value = 0;
      } else {
        _controller.forward(from: 0);
      }
    }
  }

  static bool _sameRows(List<PredictorComparisonRow> a, List<PredictorComparisonRow> b) {
    if (identical(a, b)) {
      return true;
    }
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i].position != b[i].position ||
          a[i].predictedDriverId != b[i].predictedDriverId ||
          a[i].actualDriverId != b[i].actualDriverId ||
          a[i].isCorrect != b[i].isCorrect) {
        return false;
      }
    }
    return true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rows.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        final t = _progress.value;
        final shownPoints = (widget.points * t).round();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.pointsLabelBuilder(shownPoints),
              style: AppStyles.caption.copyWith(color: context.colors.textGray),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < widget.rows.length; i++) ...[
              _RevealRow(
                reveal: _rowReveal(t, i, widget.rows.length),
                child: PredictorComparisonTile(
                  row: widget.rows[i],
                  driversById: widget.driversById,
                  predictedLabel: widget.predictedLabel,
                  actualLabel: widget.actualLabel,
                ),
              ),
              if (i != widget.rows.length - 1) const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }

  /// Доля появления строки [index] при общем прогрессе [t].
  static double _rowReveal(double t, int index, int count) {
    if (count <= 1) {
      return t;
    }
    final start = index / count;
    final end = (index + 1) / count;
    if (t <= start) {
      return 0;
    }
    if (t >= end) {
      return 1;
    }
    return ((t - start) / (end - start)).clamp(0.0, 1.0);
  }
}

/// Обёртка строки: прозрачность, сдвиг и акцентный rail через [CustomPainter].
class _RevealRow extends StatelessWidget {
  const _RevealRow({required this.reveal, required this.child});

  final double reveal;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = Curves.easeOut.transform(reveal.clamp(0.0, 1.0));
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, 12 * (1 - t)),
        child: CustomPaint(
          painter: _RevealAccentPainter(reveal: t, accent: AppTheme.red),
          child: child,
        ),
      ),
    );
  }
}

/// Короткая вспышка акцента слева при появлении строки.
class _RevealAccentPainter extends CustomPainter {
  _RevealAccentPainter({required this.reveal, required this.accent});

  final double reveal;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    if (reveal <= 0 || reveal >= 1) {
      return;
    }
    final h = size.height * reveal;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, (size.height - h) / 2, 4, h),
        const Radius.circular(2),
      ),
      Paint()..color = accent.withValues(alpha: 0.55 * (1 - reveal)),
    );
  }

  @override
  bool shouldRepaint(covariant _RevealAccentPainter oldDelegate) {
    return oldDelegate.reveal != reveal || oldDelegate.accent != accent;
  }
}
