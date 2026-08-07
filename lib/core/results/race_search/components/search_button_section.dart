import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Кнопка запуска поиска с индикатором загрузки.
class SearchButtonSection extends ConsumerWidget {
  const SearchButtonSection({required this.languageCode, super.key});

  final String languageCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(raceSearchScreenControllerProvider(languageCode));
    final controller = ref.read(raceSearchScreenControllerProvider(languageCode).notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
      child: state.dataIsLoaded
          ? BlackButton(
              isDisabled: !state.fieldsInputted,
              onTap: controller.loadRaceResults,
              text: context.l10n.search,
            )
          : const CustomLoadingIndicator(),
    );
  }
}
