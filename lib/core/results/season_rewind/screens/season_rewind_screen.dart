import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/season_rewind_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_field.dart';
import 'package:f1_pet_project/core/results/season_rewind/components/season_rewind_charts_section.dart';
import 'package:f1_pet_project/core/results/season_rewind/components/season_rewind_scrubber.dart';
import 'package:f1_pet_project/core/results/season_rewind/controllers/season_rewind_screen_controller/season_rewind_screen_controller.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран перемотки standings по раундам сезона (racing-bar chart).
@RoutePage()
class SeasonRewindScreen extends ConsumerStatefulWidget {
  const SeasonRewindScreen({super.key});

  @override
  ConsumerState<SeasonRewindScreen> createState() => _SeasonRewindScreenState();
}

class _SeasonRewindScreenState extends ConsumerState<SeasonRewindScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(analyticsGatewayProvider).log(const SeasonRewindOpened());
      return ref.read(seasonRewindScreenControllerProvider.notifier).bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seasonRewindScreenControllerProvider);
    final controller = ref.read(seasonRewindScreenControllerProvider.notifier);
    final racesLoading = state.races.isLoading;
    final standingsLoading = state.chartLoading;
    final racesList = state.races.value;
    final hasRaces = racesList != null && racesList.isNotEmpty;

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.seasonRewindTitle, onPop: () => context.router.maybePop()),
      body: SafeArea(
        child: state.races.isError && !racesLoading
            ? ErrorBody(
                onTap: controller.refreshAll,
                title: state.screenError!.title,
                subtitle: state.screenError!.subtitle,
              )
            : RefreshIndicator(
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
                            selectedIndex: state.selectedRoundIndex,
                            isPlaying: state.isPlaying,
                            canPlay: state.canPlay,
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
                      if (standingsLoading && !state.hasChartData)
                        const SliverToBoxAdapter(child: SeasonRewindShimmer(showScrubber: false))
                      else if (state.hasChartData)
                        SliverToBoxAdapter(
                          child: SeasonRewindChartsSection(
                            driversStandings: state.chartDrivers,
                            constructorsStandings: state.chartConstructors,
                          ),
                        )
                      else if (state.isChartStale)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(StaticData.defaultHorizontalPadding),
                            child: ErrorBody(
                              onTap: controller.loadStandingsForSelectedRound,
                              title: state.screenError?.title ?? context.l10n.seasonRewindLoadError,
                              subtitle: state.screenError?.subtitle,
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
