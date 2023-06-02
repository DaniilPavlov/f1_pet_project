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

  static final _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/home',
    restorationScopeId: 'router',
    // redirect: (context, state) => '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        restorationScopeId: 'shellRouteOne',
        pageBuilder: (
          context,
          state,
          navigationShell,
        ) {
          debugPrint(state.fullPath);
          return MaterialPage<void>(
            restorationId: 'shellRouteOneScaffold',
            child: ScaffoldWithNavBar(navigationShell: navigationShell),
          );
        },
        branches: [
          homeBranch,
          resultsBranch,
          scheduleBranch,
          hallOfFameBranch,
          circuitsBranch,
        ],
      ),
    ],
  );

  GoRouter get router => _router;
}
