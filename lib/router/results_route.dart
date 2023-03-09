import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/race_search_screen.dart';
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
      path: 'race_info',
      page: RaceInfoScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute<dynamic>(
      path: 'race_search',
      page: RaceSearchScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
  ],
);
