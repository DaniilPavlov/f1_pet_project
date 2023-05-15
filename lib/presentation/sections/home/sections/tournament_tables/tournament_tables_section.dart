import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/switcher/tables_switcher_consumer.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/tables/tournament_constructors_table.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/tables/tournament_drivers_table.dart';
import 'package:f1_pet_project/providers/home/home_providers.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TournamentTablesSection extends StatelessWidget {
  final List<DriverStandingsModel> driversStandings;
  final List<ConstructorStandingsModel> constructorsStandings;
  final String season;
  final String round;
  const TournamentTablesSection({
    required this.driversStandings,
    required this.constructorsStandings,
    required this.season,
    required this.round,
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
              const SizedBox(height: StaticData.defaultVerticallPadding),
              const Text(
                'Турнирная таблица текущего сезона',
                style: AppStyles.h1,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Сезон: $season',
                    style: AppStyles.h2,
                  ),
                  Text(
                    'Раунд: $round',
                    style: AppStyles.h2,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Consumer(
          // 2. specify the builder and obtain a WidgetRef
          builder: (_, ref, __) {
            final activeTable = ref.watch(homeActiveTableProvider);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const TablesSwitcherConsumer(),
                if (activeTable == 0)
                  TournamentDriversTable(
                    drivers: driversStandings,
                  )
                else
                  TournamentConstructorsTable(
                    constructors: constructorsStandings,
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
