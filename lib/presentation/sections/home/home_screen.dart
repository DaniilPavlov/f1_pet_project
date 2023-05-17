import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/domain/sections/home/home_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/tournament_tables_section.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';

@RoutePage()  
class HomeScreen extends ElementaryWidget<IHomeScreenWM> {
  const HomeScreen({super.key}) : super(createHomeScreenWM);

  @override
  Widget build(IHomeScreenWM wm) {
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
  final IHomeScreenWM wm;
  const _Body({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        SliverToBoxAdapter(
          child: EntityStateNotifierBuilder<List<ConstructorStandingsModel>>(
            listenableEntityState: wm.currentConstructors,
            builder: (_, constructors) =>
                EntityStateNotifierBuilder<List<DriverStandingsModel>>(
              listenableEntityState: wm.currentDrivers,
              builder: (_, drivers) {
                return drivers == null || constructors == null
                    ? const SizedBox()
                    : TournamentTablesSection(
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
