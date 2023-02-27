import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/current_constructors_standing/current_constractors_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/current_drivers_standings/current_drivers_standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/wm/tournament_tables_section_wm.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_tables/widgets/tables_switcher.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_tables/widgets/tournament_constructors_table.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_tables/widgets/tournament_drivers_table.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TournamentTableSection
    extends ElementaryWidget<TournamentTablesSectionWM> {
  final List<DriversStandingsList> driversStandings;
  final List<ConstructorsStandingsList> constructorsStandings;
  const TournamentTableSection({
    required this.driversStandings,
    required this.constructorsStandings,
    super.key,
  }) : super(createTournamentTableSectionWM);

  @override
  Widget build(TournamentTablesSectionWM wm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
                    'Сезон: ${driversStandings[0].season}',
                    style: AppStyles.h2,
                  ),
                  Text(
                    'Раунд: ${driversStandings[0].round}',
                    style: AppStyles.h2,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        StateNotifierBuilder<int>(
          listenableState: wm.activePage,
          builder: (_, activePage) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TablesSwitcher(wm: wm),
              if (wm.activePage.value == 0)
                TournamentDriversTable(
                  drivers: driversStandings[0].driverStandings,
                )
              else
                TournamentConstructorsTable(
                  constructors: constructorsStandings[0].constructorStandings,
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
