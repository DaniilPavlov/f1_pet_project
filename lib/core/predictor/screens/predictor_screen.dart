import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_driver_tile.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_history_tile.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_weekend_header.dart';
import 'package:f1_pet_project/core/predictor/controllers/predictor_screen_controller/predictor_screen_controller.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season_summary.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран предиктора: текущий уикенд + история сезона.
@RoutePage()
class PredictorScreen extends StatelessWidget {
  const PredictorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = context.read<LocaleController>();

    return Observer(
      builder: (context) {
        final localeCode = localeController.locale.languageCode;

        return Provider<PredictorScreenController>(
          key: ValueKey('predictor_$localeCode'),
          create: (context) => PredictorScreenController(
            predictorRepository: context.read<PredictorRepository>(),
            scheduleRepository: context.read<ScheduleRepository>(),
            driverCatalogRepository: context.read<DriverCatalogRepository>(),
            raceWeekendRepository: context.read<RaceWeekendRepository>(),
            dataRefresh: context.read<AppDataRefresh>(),
          )..load(),
          dispose: (_, controller) => controller.dispose(),
          child: Scaffold(
            appBar: CustomAppBar(title: context.l10n.predictorTitle),
            body: SafeArea(
              child: Observer(
                builder: (context) {
                  final controller = context.read<PredictorScreenController>();
                  if (controller.screenError != null) {
                    return ErrorBody(
                      onTap: controller.refreshAll,
                      title: controller.screenError!.title,
                      subtitle: controller.screenError!.subtitle,
                    );
                  }
                  if (!controller.allDataIsLoaded) {
                    return const CustomLoadingIndicator();
                  }

                  return _PredictorBody(controller: controller);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PredictorBody extends StatelessWidget {
  const _PredictorBody({required this.controller});

  final PredictorScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final year = controller.seasonYear ?? '—';
        final race = controller.upcomingRace;
        final history = controller.historyWeekends;
        final archivedSeasons = controller.archivedSeasonSummaries;
        final locked = controller.isLocked;
        final selectedGrid = controller.selectedGrid;
        final order = selectedGrid == PredictorGridKind.qualifying
            ? controller.draftQualifyingOrder
            : controller.draftRaceOrder;
        final byId = controller.driversById;
        final prediction = controller.currentPrediction;
        final waitingResults = locked &&
            prediction != null &&
            prediction.qualiPoints == null &&
            prediction.racePoints == null;

        return RefreshIndicator(
          color: AppTheme.red,
          onRefresh: controller.refreshAll,
          child: ScrollConfiguration(
            behavior: AntiGlowBehavior(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    StaticData.defaultHorizontalPadding,
                    StaticData.defaultVerticalPadding,
                    StaticData.defaultHorizontalPadding,
                    8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      context.l10n.predictorSeasonPoints(year, controller.seasonTotalPoints),
                      style: AppStyles.h3,
                    ),
                  ),
                ),
                if (race == null)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
                    sliver: SliverToBoxAdapter(
                      child: Text(context.l10n.predictorNoUpcoming, style: AppStyles.body),
                    ),
                  )
                else ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
                    sliver: SliverToBoxAdapter(
                      child: PredictorWeekendHeader(
                        race: race,
                        isLocked: locked,
                        missingQualifyingTime: controller.missingQualifyingTime,
                        lockCountdown: controller.lockCountdown,
                        waitingResults: waitingResults,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      StaticData.defaultHorizontalPadding,
                      16,
                      StaticData.defaultHorizontalPadding,
                      8,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: SegmentedButton<PredictorGridKind>(
                        showSelectedIcon: false,
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppTheme.red;
                            }
                            return context.colors.white;
                          }),
                          foregroundColor: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return AppTheme.onChrome;
                            }
                            return context.colors.black;
                          }),
                          side: WidgetStatePropertyAll(
                            BorderSide(color: context.colors.textGray.withValues(alpha: 0.35)),
                          ),
                        ),
                        segments: [
                          ButtonSegment(
                            value: PredictorGridKind.qualifying,
                            label: Text(context.l10n.qualifying),
                          ),
                          ButtonSegment(
                            value: PredictorGridKind.race,
                            label: Text(context.l10n.race),
                          ),
                        ],
                        selected: {selectedGrid},
                        onSelectionChanged: (value) => controller.selectGrid(value.first),
                      ),
                    ),
                  ),
                  if (prediction != null &&
                      (prediction.qualiPoints != null || prediction.racePoints != null))
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        StaticData.defaultHorizontalPadding,
                        0,
                        StaticData.defaultHorizontalPadding,
                        8,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _CurrentPointsBanner(prediction: prediction),
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
                    sliver: SliverReorderableList(
                      itemCount: order.length,
                      onReorderItem: locked
                          ? (_, _) {}
                          : (oldIndex, newIndex) {
                              controller.reorderDraft(oldIndex: oldIndex, newIndex: newIndex);
                            },
                      itemBuilder: (context, index) {
                        final id = order[index];
                        final driver = byId[id] ??
                            DriverModel(
                              driverId: id,
                              url: '',
                              givenName: id,
                              familyName: '',
                              dateOfBirth: '',
                              nationality: '',
                              code: id,
                              permanentNumber: null,
                            );
                        return PredictorDriverTile(
                          key: ValueKey('${selectedGrid.name}_$id'),
                          index: index,
                          driver: driver,
                          enabled: !locked,
                        );
                      },
                    ),
                  ),
                ],
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    StaticData.defaultHorizontalPadding,
                    24,
                    StaticData.defaultHorizontalPadding,
                    8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(context.l10n.predictorHistoryTitle, style: AppStyles.h3),
                  ),
                ),
                if (history.isEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        context.l10n.predictorHistoryEmpty,
                        style: AppStyles.caption.copyWith(color: context.colors.textGray),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
                    sliver: SliverList.separated(
                      itemCount: history.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final weekend = history[index];
                        return PredictorHistoryTile(
                          weekend: weekend,
                          onTap: () async {
                            final season = controller.seasonYear;
                            if (season == null) {
                              return;
                            }
                            await context.router.push(
                              PredictorWeekendDetailRoute(season: season, weekend: weekend),
                            );
                          },
                        );
                      },
                    ),
                  ),
                if (archivedSeasons.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      StaticData.defaultHorizontalPadding,
                      24,
                      StaticData.defaultHorizontalPadding,
                      8,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Text(context.l10n.predictorPastSeasonsTitle, style: AppStyles.h3),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
                    sliver: SliverList.separated(
                      itemCount: archivedSeasons.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final PredictorSeasonSummary summary = archivedSeasons[index];
                        return RedBorderContainer(
                          title: context.l10n.predictorSeasonButton(
                            summary.year,
                            summary.totalPoints,
                            summary.weekendCount,
                          ),
                          onTap: () async {
                            final season = controller.seasonByYear(summary.year);
                            if (season == null) {
                              return;
                            }
                            await context.router.push(PredictorSeasonHistoryRoute(season: season));
                          },
                        );
                      },
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CurrentPointsBanner extends StatelessWidget {
  const _CurrentPointsBanner({required this.prediction});

  final PredictorWeekendPrediction prediction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final quali = prediction.qualiPoints?.toString() ?? l10n.predictorPendingPoints;
    final racePts = prediction.racePoints?.toString() ?? l10n.predictorPendingPoints;
    return Text(
      l10n.predictorWeekendPoints(quali, racePts, prediction.totalPoints),
      style: AppStyles.caption.copyWith(color: context.colors.textGray),
    );
  }
}
