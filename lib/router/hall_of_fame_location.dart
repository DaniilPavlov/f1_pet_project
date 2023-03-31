import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/constructors_champions/constructors_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/drivers_champions/drivers_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart';
import 'package:flutter/material.dart';

class HallOfFameLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => [
        '/hall_of_fame',
        '/hall_of_fame/drivers_champions',
        '/hall_of_fame/constructors_champions',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      if (state.uri.pathSegments.contains('hall_of_fame'))
        const BeamPage(
          child: HallOfFameScreen(),
          key: ValueKey('hall_of_fame'),
          name: 'hall_of_fame',
        ),
    ];
    if (state.uri.pathSegments.contains('drivers_champions')) {
      pages.add(
        BeamPage(
          child: DriversChampionsScreen(),
          key: const ValueKey('drivers_champions'),
          name: 'drivers_champions',
        ),
      );
    }
    if (state.uri.pathSegments.contains('constructors_champions')) {
      pages.add(
        const BeamPage(
          child: ConstructorsChampionsScreen(),
          key: ValueKey('constructors_champions'),
          name: 'constructors_champions',
        ),
      );
    }

    return pages;
  }
}
