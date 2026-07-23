import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Карточка карьеры для шаринга картинкой.
class ShareCareerCard extends StatelessWidget {
  const ShareCareerCard({
    required this.l10n,
    required this.title,
    required this.stats,
    super.key,
  });

  final AppLocalizations l10n;
  final String title;
  final CareerStats<dynamic> stats;

  @override
  Widget build(BuildContext context) {
    final items = [
      (l10n.careerStatRaces, stats.races),
      (l10n.wins, stats.wins),
      (l10n.careerStatPodiums, stats.podiums),
      (l10n.careerStatPoles, stats.poles),
    ];

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
          Text(title, style: AppStyles.h2.copyWith(fontSize: 26, height: 1.15)),
          const SizedBox(height: 6),
          Text(l10n.careerTitle, style: AppStyles.body.copyWith(color: AppTheme.textGray)),
          const SizedBox(height: 20),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.7,
            children: [
              for (final (label, value) in items)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppTheme.grayBG,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.strokeGray),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$value', style: AppStyles.h3.copyWith(fontSize: 22, color: AppTheme.red)),
                        const SizedBox(height: 2),
                        Text(label, style: AppStyles.caption.copyWith(color: AppTheme.textGray)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
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
