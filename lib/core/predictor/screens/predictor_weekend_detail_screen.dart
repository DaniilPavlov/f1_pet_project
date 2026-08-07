import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_auth_gate.dart';
import 'package:f1_pet_project/core/predictor/components/predictor_comparison_tile.dart';
import 'package:f1_pet_project/core/predictor/controllers/predictor_weekend_detail_controller/predictor_weekend_detail_controller.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран сравнения предикта уикенда с фактическими результатами.
@RoutePage()
class PredictorWeekendDetailScreen extends ConsumerWidget {
  const PredictorWeekendDetailScreen({
    required this.season,
    required this.weekend,
    super.key,
  });

  final String season;
  final PredictorWeekendPrediction weekend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = PredictorWeekendDetailArgs(season: season, weekend: weekend);

    return PredictorAuthGate(
      child: _WeekendDetailAuthedScreen(args: args, title: weekend.raceName),
    );
  }
}

class _WeekendDetailAuthedScreen extends ConsumerStatefulWidget {
  const _WeekendDetailAuthedScreen({required this.args, required this.title});

  final PredictorWeekendDetailArgs args;
  final String title;

  @override
  ConsumerState<_WeekendDetailAuthedScreen> createState() => _WeekendDetailAuthedScreenState();
}

class _WeekendDetailAuthedScreenState extends ConsumerState<_WeekendDetailAuthedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(predictorWeekendDetailControllerProvider(widget.args).notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(predictorWeekendDetailControllerProvider(widget.args));
    final controller = ref.read(predictorWeekendDetailControllerProvider(widget.args).notifier);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        onPop: () => context.router.maybePop(),
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (!state.allDataIsLoaded && state.qualifyingCompare.isLoading && state.raceCompare.isLoading) {
              return const CustomLoadingIndicator();
            }
            if (state.screenError != null &&
                state.qualifyingCompare.value == null &&
                state.raceCompare.value == null) {
              return ErrorBody(
                onTap: controller.refreshAll,
                title: state.screenError!.title,
                subtitle: state.screenError!.subtitle,
              );
            }

            final compare = state.activeCompare;
            final points = compare?.points ?? 0;

            return RefreshIndicator(
              color: AppTheme.red,
              onRefresh: controller.refreshAll,
              child: ScrollConfiguration(
                behavior: AntiGlowBehavior(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    StaticData.defaultHorizontalPadding,
                    StaticData.defaultVerticalPadding,
                    StaticData.defaultHorizontalPadding,
                    StaticData.defaultVerticalPadding,
                  ),
                  children: [
                    Text(
                      context.l10n.predictorSessionPoints(points),
                      style: AppStyles.caption.copyWith(color: context.colors.textGray),
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<PredictorDetailSession>(
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
                          value: PredictorDetailSession.qualifying,
                          label: Text(context.l10n.qualifying),
                        ),
                        ButtonSegment(
                          value: PredictorDetailSession.race,
                          label: Text(context.l10n.race),
                        ),
                      ],
                      selected: {state.selectedSession},
                      onSelectionChanged: (value) => controller.selectSession(value.first),
                    ),
                    const SizedBox(height: 16),
                    if (compare == null || compare.rows.isEmpty)
                      Text(
                        context.l10n.predictorCompareEmpty,
                        style: AppStyles.caption.copyWith(color: context.colors.textGray),
                      )
                    else
                      ...compare.rows.map(
                        (row) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: PredictorComparisonTile(
                            row: row,
                            driversById: Map.of(state.driversById),
                            predictedLabel: context.l10n.predictorPredicted,
                            actualLabel: context.l10n.predictorActual,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
