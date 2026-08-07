import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/components/race_info_table.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/race_info/components/pit_stops_table.dart';
import 'package:f1_pet_project/core/results/race_info/components/pit_stops_table_appbar.dart';
import 'package:f1_pet_project/core/results/race_info/components/qualification_table.dart';
import 'package:f1_pet_project/core/results/race_info/components/qualification_table_appbar.dart';
import 'package:f1_pet_project/core/results/race_info/components/race_info_section_pin_tracker.dart';
import 'package:f1_pet_project/core/results/race_info/components/race_info_table_appbar.dart';
import 'package:f1_pet_project/core/results/race_info/controllers/race_info_screen_controller/race_info_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter/material.dart';

/// Скролл секций race info с взаимоисключающим pin шапок.
class RaceInfoScrollBody extends StatefulWidget {
  const RaceInfoScrollBody({
    required this.raceModel,
    required this.state,
    required this.onRefresh,
    super.key,
  });

  final RacesModel raceModel;
  final RaceInfoState state;
  final Future<void> Function() onRefresh;

  @override
  State<RaceInfoScrollBody> createState() => _RaceInfoScrollBodyState();
}

class _RaceInfoScrollBodyState extends State<RaceInfoScrollBody> {
  late final RaceInfoSectionPinTracker _pinTracker;

  List<ResultsModel> get _sprintResults => widget.state.sprintResults.value ?? const <ResultsModel>[];

  List<QualifyingResultsModel> get _qualifyingResults => widget.state.qualifyingResults.value ?? const [];

  List<PitStopsModel> get _pitStops => widget.state.pitStops.value ?? const [];

  @override
  void initState() {
    super.initState();
    _pinTracker = RaceInfoSectionPinTracker(hasSprint: _sprintResults.isNotEmpty);
  }

  @override
  void didUpdateWidget(covariant RaceInfoScrollBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    _pinTracker.hasSprint = _sprintResults.isNotEmpty;
  }

  @override
  void dispose() {
    _pinTracker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sprintResults = _sprintResults;

    return RefreshIndicator(
      color: AppTheme.red,
      onRefresh: widget.onRefresh,
      child: ListenableBuilder(
        listenable: _pinTracker,
        builder: (context, _) {
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollBehavior: AntiGlowBehavior(),
            slivers: [
              SliverToBoxAdapter(child: _RaceInfoHeader(raceModel: widget.raceModel)),
              raceInfoSectionSliverAppBar(
                pinned: _pinTracker.racePinned,
                title: RaceInfoSectionTitle(context.l10n.race),
                bottom: const RaceInfoTableAppBar(),
              ),
              SliverToBoxAdapter(
                child: RaceInfoSectionVisibility(
                  section: RaceInfoPinnedSection.race,
                  tracker: _pinTracker,
                  child: RaceInfoTable(raceModel: widget.raceModel, withPrimaryRow: false),
                ),
              ),
              if (sprintResults.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: StaticData.defaultVerticalPadding)),
                raceInfoSectionSliverAppBar(
                  pinned: _pinTracker.sprintPinned,
                  title: RaceInfoSectionTitle(context.l10n.sprint),
                  bottom: const RaceInfoTableAppBar(),
                ),
                SliverToBoxAdapter(
                  child: RaceInfoSectionVisibility(
                    section: RaceInfoPinnedSection.sprint,
                    tracker: _pinTracker,
                    child: RaceInfoTable(
                      raceModel: widget.raceModel,
                      results: sprintResults,
                      withPrimaryRow: false,
                    ),
                  ),
                ),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: StaticData.defaultVerticalPadding)),
              raceInfoSectionSliverAppBar(
                pinned: _pinTracker.qualificationPinned,
                title: RaceInfoSectionTitle(context.l10n.qualifying),
                bottom: const QualificationTableAppBar(),
              ),
              SliverToBoxAdapter(
                child: RaceInfoSectionVisibility(
                  section: RaceInfoPinnedSection.qualification,
                  tracker: _pinTracker,
                  child: QualificationTable(qualifyingResults: _qualifyingResults),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: StaticData.defaultVerticalPadding)),
              raceInfoSectionSliverAppBar(
                pinned: _pinTracker.pitStopsPinned,
                title: RaceInfoSectionTitle(context.l10n.pitStops),
                bottom: const PitStopsTableAppBar(),
              ),
              SliverToBoxAdapter(
                child: RaceInfoSectionVisibility(
                  section: RaceInfoPinnedSection.pitStops,
                  tracker: _pinTracker,
                  child: PitStopsTable(pitStops: _pitStops),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RaceInfoHeader extends StatelessWidget {
  const _RaceInfoHeader({required this.raceModel});

  final RacesModel raceModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: StaticData.defaultVerticalPadding,
        left: StaticData.defaultHorizontalPadding,
        right: StaticData.defaultHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(raceModel.raceName, style: AppStyles.h2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: StaticData.defaultVerticalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(context.l10n.seasonLabel(raceModel.season), style: AppStyles.h2),
                Text(context.l10n.roundLabel(raceModel.round), style: AppStyles.h2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
