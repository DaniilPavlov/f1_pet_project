import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_field.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Поля выбора сезона и гонки.
class SearchFieldsSection extends StatelessWidget {
  const SearchFieldsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RaceSearchScreenController>();
    return Padding(
      padding: const EdgeInsets.only(
        left: StaticData.defaultHorizontalPadding,
        right: StaticData.defaultHorizontalPadding,
        bottom: StaticData.defaultVerticalPadding,
      ),
      child: Observer(
        builder: (context) {
          final seasonYear = controller.selectedSeason;
          return Column(
            children: [
              SeasonPickerField(
                controller: controller.yearController,
                onChanged: controller.onSeasonSelected,
              ),
              const SizedBox(height: 16),
              RacePickerField(
                displayController: controller.raceDisplayController,
                seasonYear: seasonYear,
                onPicked: controller.onRacePicked,
              ),
            ],
          );
        },
      ),
    );
  }
}
