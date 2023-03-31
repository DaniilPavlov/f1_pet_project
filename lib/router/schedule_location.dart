import 'package:beamer/beamer.dart';
import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart';
import 'package:flutter/material.dart';

class ScheduleLocation extends BeamLocation<BeamState> {
  @override
  List<Pattern> get pathPatterns => ['/schedule'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = [
      if (state.uri.pathSegments.contains('schedule'))
        const BeamPage(
          child: ScheduleScreen(),
          key: ValueKey('schedule'),
          name: 'schedule',
        ),
    ];
    return pages;
  }
}
