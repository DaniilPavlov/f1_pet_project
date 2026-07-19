import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

/// Маршрут вкладки «Зал славы».
final AutoRoute hallOfFameRoute = AutoRoute(
  path: 'hall_of_fame',
  page: HallOfFameRouter.page,
  children: [
    AutoRoute(path: '', page: HallOfFameRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'driver', page: DriverRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'constructor', page: ConstructorRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
  ],
);
