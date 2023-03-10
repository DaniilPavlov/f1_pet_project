import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/results/race_search/race_search_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/results/widgets/race_info_table.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/material.dart';

class SearchResultSection extends StatelessWidget {
  final IRaceSearchScreenWM wm;
  const SearchResultSection({required this.wm, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (wm.dataIsLoaded.value! && wm.searchedRace.value!.data != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: StaticData.defaultVerticallPadding,
            ),
            child: RaceInfoTable(
              rowsNumber: 3,
              raceModel: wm.searchedRace.value!.data!,
            ),
          )
        else
          const SizedBox.shrink(),
        StateNotifierBuilder<String>(
          listenableState: wm.errorMessage,
          builder: (_, errorMessage) => wm.errorMessage.value!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: StaticData.defaultVerticallPadding,
                    horizontal: StaticData.defaultHorizontalPadding,
                  ),
                  child: Text(
                    wm.errorMessage.value!,
                    style: AppStyles.body,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
