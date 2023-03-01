import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/champions/tables/constructors_champions_table.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
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
