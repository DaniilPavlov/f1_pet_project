import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/core/results/components/race_info_table.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LastRaceTableSection extends StatelessWidget {
  const LastRaceTableSection({required this.lastRace, super.key});
  final RacesModel lastRace;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Последняя гонка: ', style: AppStyles.h2),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: StaticData.defaultVerticalPadding),
                child: Text(lastRace.raceName, style: AppStyles.h2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Сезон: ${lastRace.season}', style: AppStyles.h2),
                  Text('Раунд: ${lastRace.round}', style: AppStyles.h2),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [RaceInfoTable(rowsNumber: 3, raceModel: lastRace)],
        ),
      ],
    );
  }
}
