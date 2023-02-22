import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/current_drivers_standings/current_drivers_standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_table/wm/tournament_table_section_wm.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_table/tournament_table.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TournamentTableSection
    extends ElementaryWidget<TournamentTableSectionWM> {
  final List<StandingsList> items;
  const TournamentTableSection({
    required this.items,
    super.key,
  }) : super(createTournamentTableSectionWM);

  @override
  Widget build(TournamentTableSectionWM wm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.defaultPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Турнирная таблица текущего сезона',
                style: AppStyles.h1,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сезон: ${items[0].season}',
                    style: AppStyles.h2,
                  ),
                  Text(
                    'Раунд: ${items[0].round}',
                    style: AppStyles.h2,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        TournamentTable(
          drivers: items[0].driverStandings,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
