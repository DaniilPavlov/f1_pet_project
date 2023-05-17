import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

final AutoRoute resultsRoute = AutoRoute(
  path: 'results',
  page: ResultsRouter.page,
  children: [
    AutoRoute(
      path: '',
      page: ResultsRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute(
      path: 'race_info',
      page: RaceInfoRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute(
      path: 'race_search',
      page: RaceSearchRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
  ],
);
