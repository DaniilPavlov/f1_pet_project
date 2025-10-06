import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/tournament_tables/wm/tournament_tables_section_wm.dart';
import 'package:f1_pet_project/presentation/widgets/custom_switcher.dart';
import 'package:f1_pet_project/presentation/widgets/tables/tournament_constructors_table.dart';
import 'package:f1_pet_project/presentation/widgets/tables/tournament_drivers_table.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTournamentTablesSection extends ElementaryWidget<TournamentTablesSectionWM> {
  const HomeTournamentTablesSection({
    required this.driversStandings,
    required this.constructorsStandings,
    required this.season,
    required this.round,
    super.key,
  }) : super(createTournamentTableSectionWM);
  final List<DriverStandingsModel> driversStandings;
  final List<ConstructorStandingsModel> constructorsStandings;
  final String season;
  final String round;

  @override
  Widget build(TournamentTablesSectionWM wm) {
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
              const SizedBox(height: StaticData.defaultVerticalPadding),
              const Text('Турнирная таблица текущего сезона', style: AppStyles.h1),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Сезон: $season', style: AppStyles.h2),
                  Text('Раунд: $round', style: AppStyles.h2),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
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
                TournamentDriversTable(drivers: driversStandings)
              else
                TournamentConstructorsTable(constructors: constructorsStandings),
            ],
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
