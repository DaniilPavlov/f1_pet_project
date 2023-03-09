import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/results/results_model.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_appbar.dart';
import 'package:f1_pet_project/presentation/sections/results/widgets/race_info_table.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';

import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

// TODO(pavlov): нужно продумать как показать подробную информацию
class RaceInfoScreen extends StatelessWidget {
  final List<ResultsModel> results;
  const RaceInfoScreen({
    required this.results,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Подробная информация',
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
              child: RaceInfoTable(
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
