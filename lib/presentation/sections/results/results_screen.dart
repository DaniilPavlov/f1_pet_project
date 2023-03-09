import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/results/results_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/results/sections/last_race_table/last_race_table_section.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/router/router.gr.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends ElementaryWidget<IResultsScreenWM> {
  const ResultsScreen({
    super.key,
  }) : super(createResultsScreenWM);

  @override
  Widget build(IResultsScreenWM wm) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (dataIsLoaded != null) {
              return dataIsLoaded
                  ? _Body(wm: wm)
                  : const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.red,
                      ),
                    );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final IResultsScreenWM wm;
  const _Body({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: StaticData.defaultHorizontalPadding,
            ),
            child: Text(
              'Результаты',
              style: AppStyles.h1,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: EntityStateNotifierBuilder<RacesModel>(
            listenableEntityState: wm.lastRace,
            builder: (_, lastRace) {
              return lastRace == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: LastRaceTableSection(lastRace: lastRace),
                    );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: StaticData.defaultHorizontalPadding,
            ),
            child: RedBorderContainer(
              title: 'Выбрать конкретную гонку',
              onTap: () async =>
                  context.router.navigate(const RaceSearchRoute()),
            ),
          ),
        ),
      ],
    );
  }
}
