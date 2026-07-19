import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Сетка карьерных метрик: гонки / победы / подиумы / поулы.
class CareerStatsGrid extends StatelessWidget {
  const CareerStatsGrid({
    required this.races,
    required this.wins,
    required this.podiums,
    required this.poles,
    super.key,
  });

  final int races;
  final int wins;
  final int podiums;
  final int poles;

  @override
  Widget build(BuildContext context) {
    final items = [
      (context.l10n.careerStatRaces, races),
      (context.l10n.wins, wins),
      (context.l10n.careerStatPodiums, podiums),
      (context.l10n.careerStatPoles, poles),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.85,
      children: [
        for (final (label, value) in items)
          DecoratedBox(
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
                  Text('$value', style: AppStyles.h2),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.body.copyWith(color: AppTheme.textGray),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
