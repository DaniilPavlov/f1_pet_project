import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class SearchButtonSection extends StatelessWidget {
  const SearchButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final controller = context.read<RaceSearchScreenController>();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
          child: controller.dataIsLoaded
              ? BlackButton(isDisabled: !controller.fieldsInputted, onTap: controller.loadRaceResults, text: 'Поиск')
              : const CustomLoadingIndicator(),
        );
      },
    );
  }
}
