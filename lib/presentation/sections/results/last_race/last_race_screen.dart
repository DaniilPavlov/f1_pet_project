import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/results/results_model.dart';
import 'package:f1_pet_project/presentation/sections/results/last_race/last_race_appbar.dart';
import 'package:f1_pet_project/presentation/sections/results/sections/last_race_table/last_race_table.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';

import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class LastRaceScreen extends StatelessWidget {
  final List<ResultsModel> results;
  const LastRaceScreen({
    required this.results,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(
        title: 'Результат последней гонки',
        onPop: () => context.router.removeLast(),
      ),
      body: SafeArea(
        child: CustomScrollView(
          scrollBehavior: AntiGlowBehavior(),
          slivers: [
            const SliverAppBar(
              backgroundColor: AppTheme.red,
              pinned: true,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: LastRaceAppBar(),
            ),
            SliverToBoxAdapter(
              child: LastRaceTable(
                results: results,
                withPrimaryRow: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
