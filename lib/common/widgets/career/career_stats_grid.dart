import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Сетка карьерных метрик: гонки / победы / подиумы / поулы.
///
/// Для побед/подиумов/поулов рисует долю от [races] через [CustomPainter]
/// и явный [AnimationController].
class CareerStatsGrid extends StatelessWidget {
  const CareerStatsGrid({
    required this.races,
    required this.wins,
    required this.podiums,
    required this.poles,
    this.onWinsTap,
    this.onPodiumsTap,
    this.onPolesTap,
    super.key,
  });

  final int races;
  final int wins;
  final int podiums;
  final int poles;
  final VoidCallback? onWinsTap;
  final VoidCallback? onPodiumsTap;
  final VoidCallback? onPolesTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(label: context.l10n.careerStatRaces, value: races, ratio: null, onTap: null),
      _StatItem(
        label: context.l10n.wins,
        value: wins,
        ratio: races > 0 ? wins / races : 0,
        onTap: onWinsTap,
      ),
      _StatItem(
        label: context.l10n.careerStatPodiums,
        value: podiums,
        ratio: races > 0 ? podiums / races : 0,
        onTap: onPodiumsTap,
      ),
      _StatItem(
        label: context.l10n.careerStatPoles,
        value: poles,
        ratio: races > 0 ? poles / races : 0,
        onTap: onPolesTap,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        for (final item in items)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item.value > 0 ? item.onTap : null,
              borderRadius: BorderRadius.circular(8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text('${item.value}', style: AppStyles.h2)),
                          if (item.onTap != null && item.value > 0)
                            Icon(Icons.chevron_right, color: AppTheme.red, size: 20),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.body.copyWith(color: context.colors.textGray),
                      ),
                      if (item.ratio != null) ...[
                        const SizedBox(height: 8),
                        _CareerRatioBar(ratio: item.ratio!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.label,
    required this.value,
    required this.ratio,
    required this.onTap,
  });

  final String label;
  final int value;
  final double? ratio;
  final VoidCallback? onTap;
}

/// Полоска доли метрики от числа гонок.
class _CareerRatioBar extends StatefulWidget {
  const _CareerRatioBar({required this.ratio});

  final double ratio;

  @override
  State<_CareerRatioBar> createState() => _CareerRatioBarState();
}

/// Рост полоски через [AnimationController].
class _CareerRatioBarState extends State<_CareerRatioBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _CareerRatioBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ratio != widget.ratio) {
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
    final target = widget.ratio.clamp(0.0, 1.0);
    return SizedBox(
      height: 4,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          return CustomPaint(
            painter: _CareerRatioPainter(
              progress: target * _progress.value,
              fill: AppTheme.red,
              track: AppTheme.pink.withValues(alpha: 0.45),
            ),
          );
        },
      ),
    );
  }
}

/// Дорожка и заливка доли карьерной метрики.
class _CareerRatioPainter extends CustomPainter {
  _CareerRatioPainter({
    required this.progress,
    required this.fill,
    required this.track,
  });

  final double progress;
  final Color fill;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final r = Radius.circular(size.height / 2);
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, r), Paint()..color = track);
    final w = size.width * progress.clamp(0.0, 1.0);
    if (w <= 0) {
      return;
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, size.height), r),
      Paint()..color = fill,
    );
  }

  @override
  bool shouldRepaint(covariant _CareerRatioPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fill != fill ||
        oldDelegate.track != track;
  }
}
