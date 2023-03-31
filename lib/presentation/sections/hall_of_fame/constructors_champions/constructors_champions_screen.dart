import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/constructors_champions/constructors_champions_appbar.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/sections/champions/tables/constructors_champions_table.dart';

import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ConstructorsChampionsScreen extends StatelessWidget {
  final List<StandingsListsModel> constructorsChampions;
  const ConstructorsChampionsScreen({
    required this.constructorsChampions,
    super.key,
  });

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
              title: ConstructorsChampionsAppBar(),
            ),
            SliverToBoxAdapter(
              child: ConstructorsChampionsTable(
                constructors: constructorsChampions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
