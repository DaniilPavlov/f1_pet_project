import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Карточка результатов гонки для шаринга картинкой.
class ShareRaceResultsCard extends StatelessWidget {
  const ShareRaceResultsCard({
    required this.l10n,
    required this.race,
    this.topN = 10,
    super.key,
  });

  final AppLocalizations l10n;
  final RacesModel race;
  final int topN;

  @override
  Widget build(BuildContext context) {
    final results = race.results ?? const <ResultsModel>[];
    final rows = results.take(topN).toList();

    return Container(
      width: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(color: AppTheme.red, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 40, height: 4, color: AppTheme.red),
          const SizedBox(height: 16),
          Text(race.raceName, style: AppStyles.h2.copyWith(fontSize: 24, height: 1.15)),
          const SizedBox(height: 6),
          Text(
            '${race.season} · ${l10n.roundLabel(race.round)}',
            style: AppStyles.body.copyWith(color: AppTheme.textGray),
          ),
          const SizedBox(height: 16),
          if (rows.isEmpty)
            Text(l10n.shareNoResults, style: AppStyles.body)
          else
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) const Divider(height: 1, color: AppTheme.strokeGray),
              _ResultRow(result: rows[i]),
            ],
          if (results.length > topN) ...[
            const SizedBox(height: 8),
            Text(
              l10n.shareAndMore(results.length - topN),
              style: AppStyles.caption.copyWith(color: AppTheme.textGray),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Image.asset('assets/app_logo.png', height: 18),
              const SizedBox(width: 8),
              Text('F1 App', style: AppStyles.caption.copyWith(color: AppTheme.textGray)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result});

  final ResultsModel result;

  @override
  Widget build(BuildContext context) {
    final name = '${result.driver.givenName} ${result.driver.familyName}'.trim();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              result.positionText,
              style: AppStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                color: result.isClassified ? AppTheme.black : AppTheme.red,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppStyles.body.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  result.constructor.name,
                  style: AppStyles.caption.copyWith(color: AppTheme.textGray),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            result.displayTimeOrStatus,
            style: AppStyles.caption.copyWith(
              color: result.isClassified ? AppTheme.black : AppTheme.red,
            ),
          ),
        ],
      ),
    );
  }
}
