import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/results/results_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/results/sections/last_race_table/last_race_table_section.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ResultsScreen extends ElementaryWidget<IResultsScreenWM> {
  const ResultsScreen({super.key}) : super(createResultsScreenWM);

  @override
  Widget build(IResultsScreenWM wm) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (wm.screenError.value == null) {
              return dataIsLoaded!
                  ? _Body(wm: wm)
                  : const CustomLoadingIndicator();
            }
            return ErrorBody(
              onTap: wm.loadAllData,
              title: wm.screenError.value!.title,
              subtitle: wm.screenError.value!.subtitle,
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.wm});
  final IResultsScreenWM wm;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        SliverToBoxAdapter(
          child: EntityStateNotifierBuilder<RacesModel>(
            listenableEntityState: wm.lastRace,
            builder: (_, lastRace) {
              return lastRace == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: StaticData.defaultVerticallPadding,
                      ),
                      child: LastRaceTableSection(
                        lastRace: lastRace,
                        fastestLap: wm.fastestLap,
                      ),
                    );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: StaticData.defaultHorizontalPadding,
              vertical: StaticData.defaultVerticallPadding,
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
