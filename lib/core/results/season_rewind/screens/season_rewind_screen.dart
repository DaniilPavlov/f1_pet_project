import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/season_rewind_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_field.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/repositories/season_standings_repository.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/results/season_rewind/components/season_rewind_charts_section.dart';
import 'package:f1_pet_project/core/results/season_rewind/components/season_rewind_scrubber.dart';
import 'package:f1_pet_project/core/results/season_rewind/controllers/season_rewind_screen_controller/season_rewind_screen_controller.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран перемотки standings по раундам сезона (racing-bar chart).
@RoutePage()
class SeasonRewindScreen extends StatelessWidget {
  const SeasonRewindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<SeasonRewindScreenController>(
      create: (context) {
        context.read<AnalyticsGateway>().log(const SeasonRewindOpened());
        return SeasonRewindScreenController(
          seasonsRepository: context.read<SeasonsRepository>(),
          standingsRepository: context.read<SeasonStandingsRepository>(),
          raceWeekendRepository: context.read<RaceWeekendRepository>(),
          dataRefresh: context.read<AppDataRefresh>(),
        )..bootstrap();
      },
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.seasonRewindTitle, onPop: () => context.router.maybePop()),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<SeasonRewindScreenController>();
              final racesLoading = controller.races.isLoading;
              final standingsLoading = controller.chartLoading;
              final racesList = controller.races.value;
              final hasRaces = racesList != null && racesList.isNotEmpty;

              if (controller.races.isError && !racesLoading) {
                return ErrorBody(
                  onTap: controller.refreshAll,
                  title: controller.screenError!.title,
                  subtitle: controller.screenError!.subtitle,
                );
              }

              return RefreshIndicator(
                color: AppTheme.red,
                onRefresh: controller.refreshAll,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollBehavior: AntiGlowBehavior(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: StaticData.defaultHorizontalPadding,
                          right: StaticData.defaultHorizontalPadding,
                          top: StaticData.defaultVerticalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.seasonRewindSubtitle, style: AppStyles.caption),
                            const SizedBox(height: 16),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.5,
                                child: SeasonPickerField(
                                  controller: controller.yearController,
                                  onChanged: controller.onSeasonChanged,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (racesLoading)
                      const SliverToBoxAdapter(child: SeasonRewindShimmer())
                    else if (!hasRaces)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(StaticData.defaultHorizontalPadding),
                            child: Text(
                              context.l10n.seasonRewindEmpty,
                              style: AppStyles.body,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: StaticData.defaultHorizontalPadding,
                            vertical: StaticData.defaultVerticalPadding,
                          ),
                          child: SeasonRewindScrubber(
                            races: racesList,
                            selectedIndex: controller.selectedRoundIndex,
                            isPlaying: controller.isPlaying,
                            canPlay: controller.canPlay,
                            isLoadingStandings: standingsLoading,
                            onDragStart: controller.stopPlayback,
                            onCommitRound: (index) {
                              controller
                                ..stopPlayback()
                                ..selectRound(index);
                            },
                            onTogglePlayback: controller.togglePlayback,
                          ),
                        ),
                      ),
                      if (standingsLoading && !controller.hasChartData)
                        const SliverToBoxAdapter(child: SeasonRewindShimmer(showScrubber: false))
                      else if (controller.hasChartData)
                        SliverToBoxAdapter(
                          child: SeasonRewindChartsSection(
                            driversStandings: controller.chartDrivers,
                            constructorsStandings: controller.chartConstructors,
                          ),
                        )
                      else if (controller.isChartStale)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(StaticData.defaultHorizontalPadding),
                            child: ErrorBody(
                              onTap: controller.loadStandingsForSelectedRound,
                              title: controller.screenError?.title ?? context.l10n.seasonRewindLoadError,
                              subtitle: controller.screenError?.subtitle,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
