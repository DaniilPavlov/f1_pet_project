import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/presentation/widgets/scaffold_with_navbar.dart';
import 'package:f1_pet_project/router/circuits_route.dart';
import 'package:f1_pet_project/router/hall_of_fame_route.dart';
import 'package:f1_pet_project/router/home_route.dart';
import 'package:f1_pet_project/router/results_route.dart';
import 'package:f1_pet_project/router/schedule_route.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen|Page,Route',
  routes: <AutoRoute>[
    AutoRoute<dynamic>(
      path: '/',
      page: CustomScaffoldWithNavBar,
      initial: true,
      children: [
        homeRoute,
        resultsRoute,
        scheduleRoute,
        hallOfFameRoute,
        circuitsRoute,
      ],
    ),
  ],
)
class $AppRouter {}
