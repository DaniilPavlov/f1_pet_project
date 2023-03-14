import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/presentation/sections/results/widgets/race_info_table.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LastRaceTableSection extends StatelessWidget {
  final RacesModel lastRace;
  final String fastestLap;

  const LastRaceTableSection({
    required this.lastRace,
    required this.fastestLap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.defaultHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Последняя гонка: ',
                style: AppStyles.h2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: StaticData.defaultVerticallPadding,
                ),
                child: Text(
                  lastRace.raceName,
                  style: AppStyles.h2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сезон: ${lastRace.season}',
                    style: AppStyles.h2,
                  ),
                  Text(
                    'Раунд: ${lastRace.round}',
                    style: AppStyles.h2,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RaceInfoTable(
              fastestLap: fastestLap,
              rowsNumber: 3,
              raceModel: lastRace,
            ),
          ],
        ),
      ],
    );
  }
}
