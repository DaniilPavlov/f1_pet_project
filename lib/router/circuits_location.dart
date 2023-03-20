import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuit/circuit_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart';
import 'package:flutter/material.dart';

class CircuitsLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/circuits', '/circuit'];

  // CircuitsLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      if (state.uri.pathSegments.contains('circuits'))
        const BeamPage(
          child: ResultsScreen(),
          key: ValueKey('circuits'),
          name: 'circuits',
        ),
    ];
    if (state.uri.pathSegments.contains('circuit')) {
      final circuitModel =
          state.queryParameters['circuit_model'] as CircuitModel;
      pages.add(
        BeamPage(
          child: CircuitScreen(circuitModel: circuitModel),
          key: const ValueKey('circuit'),
          name: 'circuit',
        ),
      );
    }

    return pages;
  }
}
