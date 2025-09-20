import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/wm/hof_tournament_tables_section_wm.dart';

import 'package:f1_pet_project/presentation/widgets/tables/tournament_constructors_table.dart';
import 'package:f1_pet_project/presentation/widgets/tables/tournament_drivers_table.dart';
import 'package:f1_pet_project/presentation/widgets/custom_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HofTournamentTablesSection extends ElementaryWidget<HofTournamentTablesSectionWM> {
  const HofTournamentTablesSection({
    required this.driversStandings,
    required this.constructorsStandings,
    super.key,
  }) : super(createHofTournamentTableSectionWM);
  final List<DriverStandingsModel> driversStandings;
  final List<ConstructorStandingsModel> constructorsStandings;

  @override
  Widget build(HofTournamentTablesSectionWM wm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        StateNotifierBuilder<int>(
          listenableState: wm.activeTable,
          builder: (_, activePage) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSwitcher(
                firstTitle: 'Пилоты',
                secondTitle: 'Конструкторы',
                onChanged: wm.changeActiveTable,
                activeValue: activePage!,
              ),
              if (wm.activeTable.value == 0)
                TournamentDriversTable(
                  drivers: driversStandings,
                )
              else
                TournamentConstructorsTable(
                  constructors: constructorsStandings,
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
