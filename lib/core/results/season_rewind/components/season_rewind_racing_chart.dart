import 'dart:math' as math;

import 'package:f1_pet_project/common/utils/constructor_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/core/results/season_rewind/models/season_rewind_bar_entry.dart';
import 'package:flutter/material.dart';

/// Animated bar-chart race: полосы едут по очкам и меняют местами при scrub/play.
class SeasonRewindRacingChart extends StatefulWidget {
  const SeasonRewindRacingChart({
    required this.entries,
    this.duration = const Duration(milliseconds: 650),
    this.rowHeight = 44,
    super.key,
  });

  final List<SeasonRewindBarEntry> entries;
  final Duration duration;
  final double rowHeight;

  @override
  State<SeasonRewindRacingChart> createState() => _SeasonRewindRacingChartState();
}

class _SeasonRewindRacingChartState extends State<SeasonRewindRacingChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Map<String, SeasonRewindBarEntry> _from = {};
  Map<String, SeasonRewindBarEntry> _to = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _to = {for (final e in widget.entries) e.id: e};
    _from = Map.of(_to);
    _controller.value = 1;
  }

  @override
  void didUpdateWidget(covariant SeasonRewindRacingChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (!_sameEntries(oldWidget.entries, widget.entries)) {
      final t = Curves.easeInOutCubic.transform(_controller.value);
      _from = {for (final e in _lerpAll(t)) e.id: e};
      _to = {for (final e in widget.entries) e.id: e};
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static bool _sameEntries(List<SeasonRewindBarEntry> a, List<SeasonRewindBarEntry> b) {
    if (identical(a, b)) {
      return true;
    }
    if (a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  List<SeasonRewindBarEntry> _lerpAll(double t) {
    final ids = <String>{..._from.keys, ..._to.keys};
    final exitRank = math.max(_from.length, _to.length);

    final lerped = <SeasonRewindBarEntry>[];
    for (final id in ids) {
      final a = _from[id];
      final b = _to[id];
      if (a == null && b == null) {
        continue;
      }
      if (a == null) {
        lerped.add(
          SeasonRewindBarEntry(
            id: b!.id,
            constructorId: b.constructorId,
            label: b.label,
            tag: b.tag,
            points: b.points * t,
            rank: b.rank,
          ),
        );
        continue;
      }
      if (b == null) {
        lerped.add(
          a.copyWith(
            points: a.points * (1 - t),
            rank: exitRank.toDouble(),
          ),
        );
        continue;
      }
      lerped.add(
        SeasonRewindBarEntry(
          id: b.id,
          constructorId: b.constructorId,
          label: b.label,
          tag: b.tag,
          points: a.points + (b.points - a.points) * t,
          rank: a.rank + (b.rank - a.rank) * t,
        ),
      );
    }

    // Прячем почти ушедших.
    return lerped.where((e) => e.points > 0.05 || _to.containsKey(e.id)).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty && _to.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = Curves.easeInOutCubic.transform(_controller.value);
        final entries = _lerpAll(t);
        final visibleCount = math.max(_to.length, 1);
        final maxPoints = entries.fold<double>(1, (m, e) => math.max(m, e.points));

        return SizedBox(
          height: visibleCount * widget.rowHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (final entry in entries)
                Positioned(
                  key: ValueKey(entry.id),
                  left: 0,
                  right: 0,
                  top: entry.rank * widget.rowHeight,
                  height: widget.rowHeight,
                  child: _RacingBarRow(
                    entry: entry,
                    maxPoints: maxPoints,
                    isLeader: entry.rank < 0.5,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _RacingBarRow extends StatelessWidget {
  const _RacingBarRow({
    required this.entry,
    required this.maxPoints,
    required this.isLeader,
  });

  final SeasonRewindBarEntry entry;
  final double maxPoints;
  final bool isLeader;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final base = ConstructorColors.forConstructorId(entry.constructorId);
    final widthFactor = (entry.points / maxPoints).clamp(0.0, 1.0);
    final pointsLabel = entry.points == entry.points.roundToDouble()
        ? entry.points.toInt().toString()
        : entry.points.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${entry.rank.round() + 1}',
              style: AppStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: isLeader ? base : colors.textGray,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 88,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    entry.label,
                    style: AppStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (entry.tag.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Text(
                    entry.tag,
                    style: AppStyles.caption.copyWith(
                      fontSize: 10,
                      color: colors.textGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = math.max<double>(8, constraints.maxWidth * widthFactor);
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(
                      height: 22,
                      decoration: BoxDecoration(
                        color: colors.grayBG,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    Container(
                      width: barWidth,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          colors: [
                            base.withValues(alpha: 0.85),
                            base,
                          ],
                        ),
                        boxShadow: isLeader
                            ? [
                                BoxShadow(
                                  color: base.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              pointsLabel,
              style: AppStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: isLeader ? base : colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
