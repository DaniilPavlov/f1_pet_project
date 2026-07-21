import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

/// Маршрут вкладки «Результаты» с экранами гонки и поиска.
final AutoRoute resultsRoute = AutoRoute(
  path: 'results',
  page: ResultsRouter.page,
  children: [
    AutoRoute(path: '', page: ResultsRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'race_info', page: RaceInfoRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'race_search', page: RaceSearchRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'hall_of_fame', page: HallOfFameRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'h2h', page: H2hRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'h2h_constructors', page: H2hConstructorsRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'finish_status', page: FinishStatusRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'driver', page: DriverRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'constructor', page: ConstructorRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'circuit', page: CircuitRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
  ],
);
