import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuit/circuit_screen.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';
import 'package:flutter/material.dart';

class CircuitsLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/circuits', '/circuits/circuit'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      if (state.uri.pathSegments.contains('circuits'))
        const BeamPage(
          child: CircuitsScreen(),
          key: ValueKey('circuits'),
          name: 'circuits',
        ),
    ];
    if (state.uri.pathSegments.contains('circuit')) {
      pages.add(
        const BeamPage(
          child: CircuitScreen(),
          key: ValueKey('circuit'),
          name: 'circuit',
        ),
      );
    }

    return pages;
  }
}
