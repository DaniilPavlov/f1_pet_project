import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:f1_pet_project/presentation/sections/results/certain_race/certain_race_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/last_race/last_race_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart';

const resultsRoute = AutoRoute<dynamic>(
  path: 'results',
  page: EmptyRouterScreen,
  name: 'ResultsRouter',
  children: <AutoRoute>[
    AutoRoute<dynamic>(
      path: '',
      page: ResultsScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute<dynamic>(
      path: 'last_race',
      page: LastRaceScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute<dynamic>(
      path: 'certain_race',
      page: CertainRaceScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
  ],
);
