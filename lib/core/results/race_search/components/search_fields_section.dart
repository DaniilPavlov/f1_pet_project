import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_field.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Поля выбора сезона и гонки.
class SearchFieldsSection extends ConsumerWidget {
  const SearchFieldsSection({required this.languageCode, super.key});

  final String languageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(raceSearchScreenControllerProvider(languageCode));
    final controller = ref.read(raceSearchScreenControllerProvider(languageCode).notifier);
    return Padding(
      padding: const EdgeInsets.only(
        left: StaticData.defaultHorizontalPadding,
        right: StaticData.defaultHorizontalPadding,
        bottom: StaticData.defaultVerticalPadding,
      ),
      child: Column(
        children: [
          SeasonPickerField(
            controller: controller.yearController,
            onChanged: controller.onSeasonSelected,
          ),
          const SizedBox(height: 16),
          RacePickerField(
            displayController: controller.raceDisplayController,
            seasonYear: state.selectedSeason,
            onPicked: controller.onRacePicked,
          ),
        ],
      ),
    );
  }
}
