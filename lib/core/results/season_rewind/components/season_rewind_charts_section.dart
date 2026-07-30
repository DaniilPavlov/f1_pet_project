import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/custom_switcher.dart';
import 'package:f1_pet_project/core/results/season_rewind/components/season_rewind_racing_chart.dart';
import 'package:f1_pet_project/core/results/season_rewind/models/season_rewind_bar_mapper.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:flutter/material.dart';

/// Переключатель пилоты/команды + animated racing bars.
class SeasonRewindChartsSection extends StatefulWidget {
  const SeasonRewindChartsSection({
    required this.driversStandings,
    required this.constructorsStandings,
    super.key,
  });

  final List<DriverStandingsModel> driversStandings;
  final List<ConstructorStandingsModel> constructorsStandings;

  @override
  State<SeasonRewindChartsSection> createState() => _SeasonRewindChartsSectionState();
}

class _SeasonRewindChartsSectionState extends State<SeasonRewindChartsSection> {
  int _activeTable = 0;

  @override
  Widget build(BuildContext context) {
    final entries = _activeTable == 0
        ? SeasonRewindBarMapper.fromDrivers(widget.driversStandings)
        : SeasonRewindBarMapper.fromConstructors(widget.constructorsStandings);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomSwitcher(
          firstTitle: context.l10n.drivers,
          secondTitle: context.l10n.constructors,
          onChanged: (value) => setState(() => _activeTable = value),
          activeValue: _activeTable,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            StaticData.defaultHorizontalPadding,
            0,
            StaticData.defaultHorizontalPadding,
            StaticData.defaultVerticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.seasonRewindChartHint,
                style: AppStyles.caption,
              ),
              const SizedBox(height: 12),
              SeasonRewindRacingChart(entries: entries),
            ],
          ),
        ),
      ],
    );
  }
}
