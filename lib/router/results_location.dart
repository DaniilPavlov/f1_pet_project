import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/race_search_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart';
import 'package:flutter/material.dart';

class ResultsLocation extends BeamLocation<BeamState> {
  // TODO(pavlov): не понятно как передавать данные (например в рейс инфо)
  @override
  List<Pattern> get pathPatterns => [
        '/results',
        '/results/race_info',
        '/results/race_search',
        '/results/race_search/race_info',
      ];

  // ResultsLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      if (state.uri.pathSegments.contains('results'))
        const BeamPage(
          child: ResultsScreen(),
          key: ValueKey('results'),
          name: 'results',
        ),
    ];
    if (state.uri.pathSegments.contains('race_search')) {
      pages.add(
        const BeamPage(
          child: RaceSearchScreen(),
          key: ValueKey('race_search'),
          name: 'race_search',
        ),
      );
    }
    if (state.uri.pathSegments.contains('race_info')) {
      final raceModel = state.queryParameters['race_model'] as RacesModel;
      pages.add(
        BeamPage(
          child: RaceInfoScreen(raceModel: raceModel),
          key: const ValueKey('race_info'),
          name: 'race_info',
        ),
      );
    }

    return pages;
  }
}
