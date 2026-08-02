import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

/// Маршрут вкладки «Расписание» (+ список трасс).
final AutoRoute scheduleRoute = AutoRoute(
  path: 'schedule',
  page: ScheduleRouter.page,
  children: [
    AutoRoute(path: '', page: ScheduleRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'circuits', page: CircuitsRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'circuit', page: CircuitRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'driver', page: DriverRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'constructor', page: ConstructorRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
  ],
);
