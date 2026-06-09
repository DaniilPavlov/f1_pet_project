import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/components/race_info_table.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class SearchResultSection extends StatelessWidget {
  const SearchResultSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final controller = context.read<RaceSearchScreenController>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.dataIsLoaded && controller.searchedRace.value != null) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: StaticData.defaultHorizontalPadding,
                  right: StaticData.defaultHorizontalPadding,
                  top: StaticData.defaultVerticalPadding * 2,
                ),
                child: Text(controller.searchedRace.value!.raceName, style: AppStyles.h2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: StaticData.defaultVerticalPadding),
                child: RaceInfoTable(
                  rowsNumber: 3,
                  raceModel: controller.searchedRace.value!,
                ),
              ),
            ],
            if (controller.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: StaticData.defaultVerticalPadding,
                  horizontal: StaticData.defaultHorizontalPadding,
                ),
                child: Text(controller.errorMessage, style: AppStyles.body.copyWith(color: AppTheme.red)),
              ),
          ],
        );
      },
    );
  }
}
