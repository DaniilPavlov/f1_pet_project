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
import 'package:f1_pet_project/core/results/season_rewind/providers.dart';
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
      return ref.read(seasonRewindPageManagerProvider).bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(seasonRewindPageStateHolderProvider);
    final manager = ref.watch(seasonRewindPageManagerProvider);
    final racesLoading = viewModel.races.isLoading;
    final standingsLoading = viewModel.chartLoading;
    final racesList = viewModel.races.value;
    final hasRaces = racesList != null && racesList.isNotEmpty;

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.seasonRewindTitle, onPop: () => context.router.maybePop()),
      body: SafeArea(
        child: viewModel.races.isError && !racesLoading
            ? ErrorBody(
                onTap: manager.refreshAll,
                title: viewModel.screenError!.title,
                subtitle: viewModel.screenError!.subtitle,
              )
            : RefreshIndicator(
                color: AppTheme.red,
                onRefresh: manager.refreshAll,
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
                                  controller: manager.yearController,
                                  onChanged: manager.onSeasonChanged,
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
                            selectedIndex: viewModel.selectedRoundIndex,
                            isPlaying: viewModel.isPlaying,
                            canPlay: viewModel.canPlay,
                            onDragStart: manager.stopPlayback,
                            onCommitRound: (index) {
                              manager
                                ..stopPlayback()
                                ..selectRound(index);
                            },
                            onTogglePlayback: manager.togglePlayback,
                          ),
                        ),
                      ),
                      if (standingsLoading && !viewModel.hasChartData)
                        const SliverToBoxAdapter(child: SeasonRewindShimmer(showScrubber: false))
                      else if (viewModel.hasChartData)
                        SliverToBoxAdapter(
                          child: SeasonRewindChartsSection(
                            driversStandings: viewModel.chartDrivers,
                            constructorsStandings: viewModel.chartConstructors,
                          ),
                        )
                      else if (viewModel.isChartStale)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(StaticData.defaultHorizontalPadding),
                            child: ErrorBody(
                              onTap: manager.loadStandingsForSelectedRound,
                              title: viewModel.screenError?.title ?? context.l10n.seasonRewindLoadError,
                              subtitle: viewModel.screenError?.subtitle,
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
