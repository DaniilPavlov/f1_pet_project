import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:f1_pet_project/presentation/widgets/scaffold_with_navbar.dart';
import 'package:f1_pet_project/router/circuits_route.dart';
import 'package:f1_pet_project/router/hall_of_fame_route.dart';
import 'package:f1_pet_project/router/home_route.dart';
import 'package:f1_pet_project/router/results_route.dart';
import 'package:f1_pet_project/router/schedule_route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final navbarNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/home',
    redirect: (context, state) => '/home',
    routes: [
      ShellRoute(
        navigatorKey: navbarNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          circuitsRoute,
          hallOfFameRoute,
          homeRoute,
          resultsRoute,
          scheduleRoute,
        ],
      ),
    ],
  );
}
