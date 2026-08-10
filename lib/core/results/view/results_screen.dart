import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/cached_data_banner.dart';
import 'package:f1_pet_project/common/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/on_app_resumed.dart';
import 'package:f1_pet_project/common/widgets/shimmer/race_section_shimmer.dart';
import 'package:f1_pet_project/core/results/components/last_race_table_section.dart';
import 'package:f1_pet_project/core/results/components/weekend_scoreboard_section.dart';
import 'package:f1_pet_project/core/results/providers.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран результатов: уикенд, последняя гонка и переход к поиску.
@RoutePage()
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(resultsPageManagerProvider).loadAllData());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(resultsPageStateHolderProvider);
    final manager = ref.watch(resultsPageManagerProvider);
    final hasRace = viewModel.lastRace.value != null;
    final raceFailed = !hasRace && (viewModel.lastRace.isError || viewModel.screenError != null);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: OnAppResumed(
          onResumed: () {
            unawaited(manager.dismissOfflineBannerIfOnline());
          },
          child: RefreshIndicator(
            color: AppTheme.red,
            onRefresh: manager.refreshAll,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollBehavior: AntiGlowBehavior(),
              slivers: [
                if (viewModel.showingCachedData)
                  SliverToBoxAdapter(
                    child: CachedDataBanner(message: context.l10n.showingCachedData),
                  ),
                const SliverToBoxAdapter(child: WeekendScoreboardSection()),
                SliverToBoxAdapter(
                  child: hasRace
                      ? LastRaceTableSection(lastRace: viewModel.lastRace.value!)
                      : raceFailed
                      ? Padding(
                          padding: const EdgeInsets.all(StaticData.defaultHorizontalPadding),
                          child: ErrorBody(
                            onTap: manager.refreshAll,
                            title: viewModel.screenError?.title ?? viewModel.lastRace.error?.errorMessage ?? '',
                            subtitle: viewModel.screenError?.subtitle,
                          ),
                        )
                      : const LastRaceSectionShimmer(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.defaultHorizontalPadding,
                      vertical: StaticData.defaultVerticalPadding,
                    ),
                    child: Column(
                      children: [
                        RedBorderContainer(
                          title: context.l10n.chooseSpecificRace,
                          onTap: () async => context.router.push(const RaceSearchRoute()),
                        ),
                        const SizedBox(height: 12),
                        RedBorderContainer(
                          title: context.l10n.hallOfFameTitle,
                          onTap: () async => context.router.push(const HallOfFameRoute()),
                        ),
                        const SizedBox(height: 12),
                        RedBorderContainer(
                          title: context.l10n.seasonRewindTitle,
                          onTap: () async => context.router.push(const SeasonRewindRoute()),
                        ),
                        const SizedBox(height: 12),
                        RedBorderContainer(
                          title: context.l10n.h2hTitle,
                          onTap: () async => context.router.push(H2hRoute()),
                        ),
                        const SizedBox(height: 12),
                        RedBorderContainer(
                          title: context.l10n.finishStatusTitle,
                          onTap: () async => context.router.push(const FinishStatusRoute()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
