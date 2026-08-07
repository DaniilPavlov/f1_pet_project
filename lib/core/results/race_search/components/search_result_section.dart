import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/components/race_info_table.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Блок с результатом поиска или сообщением об ошибке.
class SearchResultSection extends ConsumerWidget {
  const SearchResultSection({required this.languageCode, super.key});

  final String languageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(raceSearchScreenControllerProvider(languageCode));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.dataIsLoaded && state.searchedRace.value != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: StaticData.defaultHorizontalPadding,
              right: StaticData.defaultHorizontalPadding,
              top: StaticData.defaultVerticalPadding * 2,
            ),
            child: Text(state.searchedRace.value!.raceName, style: AppStyles.h2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: StaticData.defaultVerticalPadding),
            child: RaceInfoTable(rowsNumber: 3, raceModel: state.searchedRace.value!),
          ),
        ],
        if (state.errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: StaticData.defaultVerticalPadding,
              horizontal: StaticData.defaultHorizontalPadding,
            ),
            child: Text(state.errorMessage, style: AppStyles.body.copyWith(color: AppTheme.red)),
          ),
      ],
    );
  }
}
