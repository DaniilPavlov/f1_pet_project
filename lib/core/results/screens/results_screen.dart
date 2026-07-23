import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/race_section_shimmer.dart';
import 'package:f1_pet_project/core/results/components/last_race_table_section.dart';
import 'package:f1_pet_project/core/results/components/weekend_scoreboard_section.dart';
import 'package:f1_pet_project/core/results/controllers/results_screen_controller/results_screen_controller.dart';
import 'package:f1_pet_project/core/results/repositories/results_repository.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран результатов: уикенд, последняя гонка и переход к поиску.
@RoutePage()
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<ResultsScreenController>(
      create: (context) => ResultsScreenController(
        resultsRepository: context.read<ResultsRepository>(),
        scoreboardRepository: context.read<EspnScoreboardRepository>(),
        dataRefresh: context.read<AppDataRefresh>(),
      )..loadAllData(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<ResultsScreenController>();
              final hasRace = controller.lastRace.value != null;
              final raceFailed = !hasRace && (controller.lastRace.isError || controller.screenError != null);

              return RefreshIndicator(
                color: AppTheme.red,
                onRefresh: controller.refreshAll,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollBehavior: AntiGlowBehavior(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: WeekendScoreboardSection(
                        scoreboard: controller.scoreboard,
                        locale: Localizations.localeOf(context),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: hasRace
                          ? LastRaceTableSection(lastRace: controller.lastRace.value!)
                          : raceFailed
                          ? Padding(
                              padding: const EdgeInsets.all(StaticData.defaultHorizontalPadding),
                              child: ErrorBody(
                                onTap: controller.refreshAll,
                                title: controller.screenError?.title ??
                                    controller.lastRace.error?.errorMessage ??
                                    '',
                                subtitle: controller.screenError?.subtitle,
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
                              onTap: () async => context.router.navigate(const RaceSearchRoute()),
                            ),
                            const SizedBox(height: 12),
                            RedBorderContainer(
                              title: context.l10n.hallOfFameTitle,
                              onTap: () async => context.router.navigate(const HallOfFameRoute()),
                            ),
                            const SizedBox(height: 12),
                            RedBorderContainer(
                              title: context.l10n.h2hTitle,
                              onTap: () async => context.router.navigate(const H2hRoute()),
                            ),
                            const SizedBox(height: 12),
                            RedBorderContainer(
                              title: context.l10n.h2hConstructorsTitle,
                              onTap: () async => context.router.navigate(const H2hConstructorsRoute()),
                            ),
                            const SizedBox(height: 12),
                            RedBorderContainer(
                              title: context.l10n.finishStatusTitle,
                              onTap: () async => context.router.navigate(const FinishStatusRoute()),
                            ),
                          ],
                        ),
                      ),
                    ),
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
