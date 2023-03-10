import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/drivers_champions/drivers_champions_appbar.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/sections/champions/tables/drivers_champions_table.dart';

import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class DriversChampionsScreen extends StatelessWidget {
  final List<StandingsListsModel> driversChampions;
  const DriversChampionsScreen({required this.driversChampions, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          scrollBehavior: AntiGlowBehavior(),
          slivers: [
            const SliverAppBar(
              backgroundColor: AppTheme.red,
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: DriversChampionsAppBar(),
            ),
            SliverToBoxAdapter(
              child: DriversChampionsTable(
                drivers: driversChampions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
