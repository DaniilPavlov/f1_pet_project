import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/router/circuits_route.dart';
import 'package:f1_pet_project/router/hall_of_fame_route.dart';
import 'package:f1_pet_project/router/home_route.dart';
import 'package:f1_pet_project/router/results_route.dart';
import 'package:f1_pet_project/router/schedule_route.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter  {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      path: '/',
      page: ScaffoldWithNavBarRoute.page,
      initial: true,
      children: [
        homeRoute,
        resultsRoute,
        scheduleRoute,
        hallOfFameRoute,
        circuitsRoute,
      ],
    ),
  ];

  @override
  RouteType get defaultRouteType => const RouteType.material();
}
