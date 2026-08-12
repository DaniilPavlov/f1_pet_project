import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/finish_status/models/finish_status_item.dart';
import 'package:flutter/material.dart';

/// Список статусов финиша с анимированными share-полосками.
///
/// Рост полосок ведёт явный [AnimationController]; заливку рисует [CustomPainter].
class FinishStatusShareList extends StatefulWidget {
  const FinishStatusShareList({
    required this.items,
    this.animationDuration = const Duration(milliseconds: 1100),
    super.key,
  });

  final List<FinishStatusItem> items;
  final Duration animationDuration;

  @override
  State<FinishStatusShareList> createState() => _FinishStatusShareListState();
}

/// Состояние появления полосок долей.
class _FinishStatusShareListState extends State<FinishStatusShareList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animationDuration);
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    if (widget.items.isNotEmpty) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant FinishStatusShareList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
    if (!_sameItems(oldWidget.items, widget.items)) {
      if (widget.items.isEmpty) {
        _controller.value = 0;
      } else {
        _controller.forward(from: 0);
      }
    }
  }

  static bool _sameItems(List<FinishStatusItem> a, List<FinishStatusItem> b) {
    if (identical(a, b)) {
      return true;
    }
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i].statusId != b[i].statusId || a[i].count != b[i].count) {
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
    if (widget.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(context.l10n.finishStatusEmpty, style: AppStyles.body),
      );
    }

    final total = widget.items.fold<int>(0, (sum, item) => sum + item.count);

    return AnimatedBuilder(
      animation: _progress,
      builder: (context, _) {
        final t = _progress.value;
        return Column(
          children: [
            for (var i = 0; i < widget.items.length; i++) ...[
              _StatusRow(
                item: widget.items[i],
                total: total,
                reveal: _rowReveal(t, i, widget.items.length),
              ),
              Divider(height: 1, color: context.colors.strokeGray),
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
    final start = index / (count + 1);
    final end = (index + 1.2) / (count + 1);
    if (t <= start) {
      return 0;
    }
    if (t >= end) {
      return 1;
    }
    return ((t - start) / (end - start)).clamp(0.0, 1.0);
  }
}

/// Строка статуса: подпись, count, % и анимированная полоска доли.
class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.item,
    required this.total,
    required this.reveal,
  });

  final FinishStatusItem item;
  final int total;
  final double reveal;

  @override
  Widget build(BuildContext context) {
    final share = total > 0 ? item.count / total : 0.0;
    final tint = item.isHighlight ? AppTheme.red : context.colors.black;
    final barColor = item.isHighlight ? AppTheme.red : AppTheme.chrome;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.status,
                  style: AppStyles.body.copyWith(
                    fontWeight: item.isHighlight ? FontWeight.w600 : FontWeight.w400,
                    color: tint,
                  ),
                ),
              ),
              Text(
                '${item.count}',
                style: AppStyles.h3.copyWith(color: tint),
              ),
              if (total > 0) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 48,
                  child: Text(
                    '${(share * 100).round()}%',
                    textAlign: TextAlign.right,
                    style: AppStyles.caption.copyWith(color: context.colors.textGray),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 6,
            child: CustomPaint(
              painter: _ShareBarPainter(
                progress: share * Curves.easeOut.transform(reveal.clamp(0.0, 1.0)),
                color: barColor,
                track: context.colors.strokeGray.withValues(alpha: 0.55),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Горизонтальная share-полоска (дорожка + заливка доли).
class _ShareBarPainter extends CustomPainter {
  _ShareBarPainter({
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
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, r),
      Paint()..color = track,
    );
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
  bool shouldRepaint(covariant _ShareBarPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.track != track;
  }
}
