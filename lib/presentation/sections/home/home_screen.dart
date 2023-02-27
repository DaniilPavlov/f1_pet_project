import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/current_constructors_standing/current_constractors_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/current_drivers_standings/current_drivers_standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/home_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_tables/tournament_tables_section.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ElementaryWidget<HomeScreenWM> {
  const HomeScreen({
    super.key,
  }) : super(createHomeScreenWM);

  @override
  Widget build(HomeScreenWM wm) {
    return Scaffold(
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (dataIsLoaded != null) {
              return dataIsLoaded
                  ? _body(wm: wm)
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

class _body extends StatelessWidget {
  final HomeScreenWM wm;
  const _body({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        //
        SliverToBoxAdapter(
          child: EntityStateNotifierBuilder<List<ConstructorsStandingsList>>(
            listenableEntityState: wm.currentConstructorsElements,
            builder: (_, constructors) =>
                EntityStateNotifierBuilder<List<DriversStandingsList>>(
              listenableEntityState: wm.currentDriversElements,
              builder: (_, drivers) {
                return drivers == null || constructors == null
                    ? const SizedBox()
                    : TournamentTableSection(
                        driversStandings: drivers,
                        constructorsStandings: constructors,
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
