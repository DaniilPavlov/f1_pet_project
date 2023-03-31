import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:flutter/material.dart';

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/home'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      if (state.uri.pathSegments.contains('home'))
        const BeamPage(
          child: HomeScreen(),
          key: ValueKey('home'),
          name: 'home',
        ),
    ];
    return pages;
  }
}
