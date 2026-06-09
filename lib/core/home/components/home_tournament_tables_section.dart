import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/custom_switcher.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_constructors_table.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_drivers_table.dart';
import 'package:f1_pet_project/core/home/controllers/tournament_tables_section_controller/tournament_tables_section_controller.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_standings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class HomeTournamentTablesSection extends StatelessWidget {
  const HomeTournamentTablesSection({
    required this.driversStandings,
    required this.constructorsStandings,
    required this.season,
    required this.round,
    super.key,
  });

  final List<DriverStandingsModel> driversStandings;
  final List<ConstructorStandingsModel> constructorsStandings;
  final String season;
  final String round;

  @override
  Widget build(BuildContext context) {
    return Provider<TournamentTablesSectionController>(
      create: (_) => TournamentTablesSectionController(),
      child: Observer(
        builder: (context) {
          final controller = context.read<TournamentTablesSectionController>();
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
              CustomSwitcher(
                firstTitle: 'Пилоты',
                secondTitle: 'Конструкторы',
                onChanged: controller.changeActiveTable,
                activeValue: controller.activeTable,
              ),
              if (controller.activeTable == 0)
                TournamentDriversTable(drivers: driversStandings)
              else
                TournamentConstructorsTable(constructors: constructorsStandings),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}
