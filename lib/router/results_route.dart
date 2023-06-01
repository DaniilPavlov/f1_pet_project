import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/race_search_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch resultsBranch = StatefulShellBranch(
  restorationScopeId: 'branchResults',
  routes: <RouteBase>[
    GoRoute(
      path: '/results',
      pageBuilder: (context, state) => const NoTransitionPage<dynamic>(
        child: ResultsScreen(),
      ),
      routes: [
        GoRoute(
          path: 'race_info',
          builder: (context, state) => RaceInfoScreen(
            raceModel: state.extra as RacesModel,
          ),
        ),
        GoRoute(
          path: 'race_search',
          builder: (context, state) => const RaceSearchScreen(),
        ),
      ],
    ),
  ],
);
