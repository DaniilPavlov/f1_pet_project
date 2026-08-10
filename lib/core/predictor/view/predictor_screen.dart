import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_auth_gate.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_driver_tile.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_history_tile.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_position_picker.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_weekend_header.dart';
import 'package:f1_pet_project/core/predictor/managers/predictor_page_manager.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season_summary.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/providers.dart';
import 'package:f1_pet_project/core/predictor/services/predictor_order.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_page_view_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран предиктора: текущий уикенд + история сезона.
@RoutePage()
class PredictorScreen extends ConsumerWidget {
  const PredictorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PredictorAuthGate(
      asTabRoot: true,
      child: _PredictorAuthedScreen(),
    );
  }
}

class _PredictorAuthedScreen extends ConsumerStatefulWidget {
  const _PredictorAuthedScreen();

  @override
  ConsumerState<_PredictorAuthedScreen> createState() => _PredictorAuthedScreenState();
}

class _PredictorAuthedScreenState extends ConsumerState<_PredictorAuthedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(predictorPageManagerProvider).load());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(predictorPageStateHolderProvider);
    final manager = ref.watch(predictorPageManagerProvider);

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.predictorTitle),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (viewModel.screenError != null) {
              return ErrorBody(
                onTap: manager.refreshAll,
                title: viewModel.screenError!.title,
                subtitle: viewModel.screenError!.subtitle,
              );
            }
            if (!viewModel.allDataIsLoaded) {
              return const CustomLoadingIndicator();
            }

            return _PredictorBody(viewModel: viewModel, manager: manager);
          },
        ),
      ),
    );
  }
}

class _PredictorBody extends StatelessWidget {
  const _PredictorBody({required this.viewModel, required this.manager});

  final PredictorPageViewModel viewModel;
  final PredictorPageManager manager;

  @override
  Widget build(BuildContext context) {
    final year = viewModel.seasonYear ?? '—';
    final race = viewModel.upcomingRace;
    final history = viewModel.historyWeekends;
    final archivedSeasons = viewModel.archivedSeasonSummaries;
    final locked = viewModel.isLocked;
    final selectedGrid = viewModel.selectedGrid;
    final order = selectedGrid == PredictorGridKind.qualifying
        ? viewModel.draftQualifyingOrder
        : viewModel.draftRaceOrder;
    final byId = viewModel.driversById;
    final constructorsById = viewModel.constructorsByDriverId;
    final prediction = viewModel.currentPrediction;
    final waitingResults = locked &&
        prediction != null &&
        prediction.qualiPoints == null &&
        prediction.racePoints == null;

    return RefreshIndicator(
      color: AppTheme.red,
      onRefresh: manager.refreshAll,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.l10n.predictorSeasonPoints(year, viewModel.seasonTotalPoints),
                      style: AppStyles.h3,
                    ),
                    if (viewModel.seasonYear != null) ...[
                      const SizedBox(height: 12),
                      BlackButton(
                        text: context.l10n.predictorLeaderboardOpen,
                        isDisabled: false,
                        midIcon: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              context.l10n.predictorLeaderboardOpen,
                              style: AppStyles.h3.copyWith(color: AppTheme.red),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_right_alt, color: AppTheme.red),
                          ],
                        ),
                        onTap: () async {
                          final seasonYear = viewModel.seasonYear!;
                          await context.router.push(
                            PredictorLeaderboardRoute(
                              year: seasonYear,
                              myPoints: viewModel.seasonTotalPoints,
                            ),
                          );
                        },
                      ),
                    ],
                  ],
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
                    missingQualifyingTime: viewModel.missingQualifyingTime,
                    lockCountdown: viewModel.lockCountdown,
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
                    onSelectionChanged: (value) => manager.selectGrid(value.first),
                  ),
                ),
              ),
              if (selectedGrid == PredictorGridKind.race && !locked)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    StaticData.defaultHorizontalPadding,
                    0,
                    StaticData.defaultHorizontalPadding,
                    8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: manager.copyQualifyingToRace,
                        style: TextButton.styleFrom(
                          foregroundColor: context.colors.black,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          context.l10n.predictorCopyQualifyingToRace,
                          style: AppStyles.caption.copyWith(
                            color: context.colors.black,
                            decoration: TextDecoration.underline,
                            decorationColor: context.colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (prediction != null && (prediction.qualiPoints != null || prediction.racePoints != null))
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
              SliverReorderableList(
                itemCount: order.length,
                onReorderItem: locked
                    ? (_, _) {}
                    : (oldIndex, newIndex) {
                        manager.reorderDraft(oldIndex: oldIndex, newIndex: newIndex);
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
                    constructor: constructorsById[id],
                    enabled: !locked,
                    onTap: locked
                        ? null
                        : () async {
                            final label = (driver.code?.isNotEmpty ?? false)
                                ? driver.code!
                                : driver.familyName;
                            final toIndex = await showPredictorPositionPicker(
                              context: context,
                              itemCount: order.length,
                              currentIndex: index,
                              driverLabel: label,
                            );
                            if (toIndex == null || !context.mounted) {
                              return;
                            }
                            await manager.moveDraftTo(fromIndex: index, toIndex: toIndex);
                          },
                  );
                },
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
                        final season = viewModel.seasonYear;
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
                        final season = manager.seasonByYear(summary.year);
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
