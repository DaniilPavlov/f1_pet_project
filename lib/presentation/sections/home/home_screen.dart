import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
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
  final HomeScreenWM wm;
  const _Body({
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
          child: EntityStateNotifierBuilder<List<ConstructorStandingsModel>>(
            listenableEntityState: wm.currentConstructorsElements,
            builder: (_, constructors) =>
                EntityStateNotifierBuilder<List<DriverStandingsModel>>(
              listenableEntityState: wm.currentDriversElements,
              builder: (_, drivers) {
                return drivers == null || constructors == null
                    ? const SizedBox()
                    : TournamentTableSection(
                        driversStandings: drivers,
                        constructorsStandings: constructors,
                        season: wm.currentSeason.value!,
                        round: wm.currentRound.value!,
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}
