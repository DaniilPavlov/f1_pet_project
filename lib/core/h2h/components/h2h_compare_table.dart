import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/h2h/models/h2h_stats.dart';
import 'package:flutter/material.dart';

/// Таблица сравнения метрик двух участников H2H.
class H2hCompareTable extends StatelessWidget {
  const H2hCompareTable({
    required this.nameA,
    required this.nameB,
    required this.statsA,
    required this.statsB,
    this.season,
    super.key,
  });

  final String nameA;
  final String nameB;
  final H2hStats statsA;
  final H2hStats statsB;
  final String? season;

  @override
  Widget build(BuildContext context) {
    final rows = [
      (context.l10n.careerStatRaces, statsA.races, statsB.races),
      (context.l10n.wins, statsA.wins, statsB.wins),
      (context.l10n.careerStatPodiums, statsA.podiums, statsB.podiums),
      (context.l10n.careerStatPoles, statsA.poles, statsB.poles),
    ];

    return Column(
      children: [
        if (season != null) ...[
          Text(
            context.l10n.seasonLabel(season!),
            style: AppStyles.caption.copyWith(color: AppTheme.textGray),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            const SizedBox(width: 100),
            Expanded(
              child: Text(nameA, style: AppStyles.body.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text(nameB, style: AppStyles.body.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final (label, a, b) in rows) ...[
          _CompareRow(label: label, valueA: a, valueB: b),
          const Divider(height: 1, color: AppTheme.strokeGray),
        ],
      ],
    );
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
            child: Text(label, style: AppStyles.caption.copyWith(color: AppTheme.textGray)),
          ),
          Expanded(
            child: Text(
              '$valueA',
              textAlign: TextAlign.center,
              style: AppStyles.h3.copyWith(
                fontSize: 22,
                color: aWins ? AppTheme.red : AppTheme.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              '$valueB',
              textAlign: TextAlign.center,
              style: AppStyles.h3.copyWith(
                fontSize: 22,
                color: bWins ? AppTheme.red : AppTheme.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
