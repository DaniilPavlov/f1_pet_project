import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/constructors_champions/constructors_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/drivers_champions/drivers_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart';
import 'package:flutter/material.dart';

class HallOfFameLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns =>
      ['/hall_of_fame', '/drivers_champions', '/constructors_champions'];

  // HallOfFameLocation(RouteInformation routeInformation)
  //     : super(routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      if (state.uri.pathSegments.contains('hall_of_fame'))
        const BeamPage(
          child: ResultsScreen(),
          key: ValueKey('hall_of_fame'),
          name: 'hall_of_fame',
        ),
    ];
    if (state.uri.pathSegments.contains('drivers_champions')) {
      final driversChampionsList = state.queryParameters['driversChampions']
          as List<StandingsListsModel>;
      pages.add(
        BeamPage(
          child: DriversChampionsScreen(driversChampions: driversChampionsList),
          key: const ValueKey('drivers_champions'),
          name: 'drivers_champions',
        ),
      );
    }
    if (state.uri.pathSegments.contains('constructors_champions')) {
      final constructorsChampionsList =
          state.queryParameters['constructorsChampions']
              as List<StandingsListsModel>;
      pages.add(
        BeamPage(
          child: ConstructorsChampionsScreen(
            constructorsChampions: constructorsChampionsList,
          ),
          key: const ValueKey('constructors_champions'),
          name: 'constructors_champions',
        ),
      );
    }

    return pages;
  }
}
