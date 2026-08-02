import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_history_tile.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

/// История предиктов за выбранный прошлый сезон.
@RoutePage()
class PredictorSeasonHistoryScreen extends StatelessWidget {
  const PredictorSeasonHistoryScreen({
    required this.season,
    super.key,
  });

  final PredictorSeason season;

  @override
  Widget build(BuildContext context) {
    final weekends = season.weekendsSorted.reversed.toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.predictorSeasonPoints(season.year, season.totalPoints),
        onPop: () => context.router.maybePop(),
      ),
      body: SafeArea(
        child: weekends.isEmpty
            ? Center(
                child: Text(
                  context.l10n.predictorHistoryEmpty,
                  style: AppStyles.caption.copyWith(color: context.colors.textGray),
                ),
              )
            : ScrollConfiguration(
                behavior: AntiGlowBehavior(),
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    StaticData.defaultHorizontalPadding,
                    StaticData.defaultVerticalPadding,
                    StaticData.defaultHorizontalPadding,
                    StaticData.defaultVerticalPadding,
                  ),
                  itemCount: weekends.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final weekend = weekends[index];
                    return PredictorHistoryTile(
                      weekend: weekend,
                      onTap: () async => context.router.push(
                        PredictorWeekendDetailRoute(
                          season: season.year,
                          weekend: weekend,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
