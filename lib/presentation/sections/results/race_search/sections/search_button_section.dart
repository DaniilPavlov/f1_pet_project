import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/domain/sections/results/race_search/race_search_screen_wm.dart';
import 'package:f1_pet_project/presentation/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:flutter/material.dart';

class SearchButtonSection extends StatelessWidget {
  const SearchButtonSection({required this.wm, super.key});
  final IRaceSearchScreenWM wm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.defaultHorizontalPadding,
      ),
      child: StateNotifierBuilder<bool>(
        listenableState: wm.fieldsInputted,
        builder: (_, fieldsInputted) {
          return wm.dataIsLoaded.value!
              ? BlackButton(
                  isDisabled: !fieldsInputted!,
                  onTap: wm.loadRaceResults,
                  text: 'Поиск',
                )
              : const CustomLoadingIndicator();
        },
      ),
    );
  }
}
