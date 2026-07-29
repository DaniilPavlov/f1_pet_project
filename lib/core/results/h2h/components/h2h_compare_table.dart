import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/h2h/components/h2h_points_chart.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_points_timeline.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_stats.dart';
import 'package:flutter/material.dart';

/// Сравнение H2H: график накопленных очков + краткие метрики.
class H2hCompareTable extends StatelessWidget {
  const H2hCompareTable({
    required this.nameA,
    required this.nameB,
    required this.statsA,
    required this.statsB,
    required this.timeline,
    this.season,
    super.key,
  });

  final String nameA;
  final String nameB;
  final H2hStats statsA;
  final H2hStats statsB;
  final H2hPointsTimeline timeline;
  final String? season;

  @override
  Widget build(BuildContext context) {
    final colorA = AppTheme.red;
    final colorB = context.colors.black;
    final rows = [
      (context.l10n.careerStatRaces, statsA.races, statsB.races),
      (context.l10n.wins, statsA.wins, statsB.wins),
      (context.l10n.careerStatPodiums, statsA.podiums, statsB.podiums),
      (context.l10n.careerStatPoles, statsA.poles, statsB.poles),
    ];
    final semanticsRows = [
      for (final (label, a, b) in rows) '$label: $nameA $a, $nameB $b',
    ];
    final last = timeline.points.isEmpty ? null : timeline.points.last;
    final pointsSemantics = last == null
        ? null
        : '${context.l10n.points}: $nameA ${_fmt(last.cumulativeA)}, $nameB ${_fmt(last.cumulativeB)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: false,
          maintainState: true,
          maintainAnimation: true,
          maintainSemantics: true,
          maintainSize: true,
          child: Semantics(
            container: true,
            liveRegion: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (season != null)
                  Semantics(
                    header: true,
                    label: context.l10n.seasonLabel(season!),
                    child: const SizedBox(width: 1, height: 1),
                  ),
                Semantics(
                  header: true,
                  label: context.l10n.h2hPointsTimelineTitle,
                  child: const SizedBox(width: 1, height: 1),
                ),
                if (pointsSemantics != null)
                  Semantics(label: pointsSemantics, child: const SizedBox(width: 1, height: 1)),
                for (final row in semanticsRows)
                  Semantics(label: row, child: const SizedBox(width: 1, height: 1)),
              ],
            ),
          ),
        ),
        ExcludeSemantics(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (season != null) ...[
                Text(
                  context.l10n.seasonLabel(season!),
                  style: AppStyles.caption.copyWith(color: context.colors.textGray),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                context.l10n.h2hPointsTimelineTitle,
                style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.h2hPointsTimelineSubtitle,
                style: AppStyles.caption.copyWith(color: context.colors.textGray),
              ),
              const SizedBox(height: 16),
              if (timeline.isEmpty)
                Text(
                  context.l10n.h2hPointsTimelineEmpty,
                  style: AppStyles.body.copyWith(color: context.colors.textGray),
                )
              else ...[
                H2hPointsChart(
                  timeline: timeline,
                  colorA: colorA,
                  colorB: colorB,
                ),
                const SizedBox(height: 12),
                H2hPointsChartLegend(
                  nameA: nameA,
                  nameB: nameB,
                  pointsA: last!.cumulativeA,
                  pointsB: last.cumulativeB,
                  colorA: colorA,
                  colorB: colorB,
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  const SizedBox(width: 100),
                  Expanded(
                    child: Text(
                      nameA,
                      style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      nameB,
                      style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final (label, a, b) in rows) ...[
                _CompareRow(label: label, valueA: a, valueB: b),
                Divider(height: 1, color: context.colors.strokeGray),
              ],
            ],
          ),
        ),
      ],
    );
  }

  static String _fmt(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({required this.label, required this.valueA, required this.valueB});

  final String label;
  final int valueA;
  final int valueB;

  @override
  Widget build(BuildContext context) {
    final aWins = valueA > valueB;
    final bWins = valueB > valueA;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: AppStyles.caption.copyWith(color: context.colors.textGray)),
          ),
          Expanded(
            child: Text(
              '$valueA',
              textAlign: TextAlign.center,
              style: AppStyles.h3.copyWith(
                fontSize: 22,
                color: aWins ? AppTheme.red : context.colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$valueB',
              textAlign: TextAlign.center,
              style: AppStyles.h3.copyWith(
                fontSize: 22,
                color: bWins ? AppTheme.red : context.colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
