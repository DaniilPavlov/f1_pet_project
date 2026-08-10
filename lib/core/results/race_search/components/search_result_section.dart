import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/components/race_info_table.dart';
import 'package:f1_pet_project/core/results/race_search/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Блок с результатом поиска или сообщением об ошибке.
class SearchResultSection extends ConsumerWidget {
  const SearchResultSection({required this.languageCode, super.key});

  final String languageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(raceSearchPageStateHolderProvider(languageCode));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (viewModel.dataIsLoaded && viewModel.searchedRace.value != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: StaticData.defaultHorizontalPadding,
              right: StaticData.defaultHorizontalPadding,
              top: StaticData.defaultVerticalPadding * 2,
            ),
            child: Text(viewModel.searchedRace.value!.raceName, style: AppStyles.h2),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: StaticData.defaultVerticalPadding),
            child: RaceInfoTable(rowsNumber: 3, raceModel: viewModel.searchedRace.value!),
          ),
        ],
        if (viewModel.errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: StaticData.defaultVerticalPadding,
              horizontal: StaticData.defaultHorizontalPadding,
            ),
            child: Text(viewModel.errorMessage, style: AppStyles.body.copyWith(color: AppTheme.red)),
          ),
      ],
    );
  }
}
