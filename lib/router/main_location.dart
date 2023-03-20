import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/presentation/widgets/app_screen.dart';
import 'package:flutter/material.dart';

class MainLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/main'];

  // HomeLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
        const BeamPage(
          child: AppScreen(),
          key: ValueKey('main'),
          name: 'main',
        ),
    ];
    return pages;
  }
}
