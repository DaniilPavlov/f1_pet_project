import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

final AutoRoute hallOfFameRoute = AutoRoute(
  path: 'hall_of_fame',
  page: HallOfFameRouter.page,
  children: [
    AutoRoute(
      path: '',
      page: HallOfFameRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute(
      path: 'drivers_champions',
      page: DriversChampionsRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute(
      path: 'constructors_champions',
      page: ConstructorsChampionsRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
  ],
);
