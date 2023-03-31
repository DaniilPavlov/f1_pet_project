import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/presentation/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChampionsSection extends StatelessWidget {
  final List<StandingsListsModel> driversChampions;
  final List<StandingsListsModel> constructorsChampions;

  const ChampionsSection({
    required this.driversChampions,
    required this.constructorsChampions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: StaticData.defaultHorizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Чемпионы всех сезонов',
            style: AppStyles.h1,
          ),
          const SizedBox(height: 32),
          RedBorderContainer(
            title: 'Пилоты',
            onTap: () => Beamer.of(context).beamToNamed(
              '/hall_of_fame/?driversChampions=$driversChampions',
            ),
          ),
          const SizedBox(height: 20),
          RedBorderContainer(
            title: 'Конструкторы',
            onTap: () => Beamer.of(context).beamToNamed(
              '/hall_of_fame/?constructorsChampions=$constructorsChampions',
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
