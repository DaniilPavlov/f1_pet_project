// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:auto_route/empty_router_widgets.dart' as _i2;
import 'package:flutter/material.dart' as _i5;

import '../presentation/sections/home/home_screen.dart' as _i3;
import '../presentation/widgets/scaffold_with_navbar.dart' as _i1;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    CustomScaffoldWithNavBar.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.CustomScaffoldWithNavBar(),
      );
    },
    HomeRouter.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
        maintainState: false,
      );
    },
    HomeRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.HomeScreen(),
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(
          CustomScaffoldWithNavBar.name,
          path: '/',
          children: [
            _i4.RouteConfig(
              HomeRouter.name,
              path: 'home',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i4.RouteConfig(
                  HomeRoute.name,
                  path: '',
                  parent: HomeRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                )
              ],
            )
          ],
        )
      ];
}

/// generated route for
/// [_i1.CustomScaffoldWithNavBar]
class CustomScaffoldWithNavBar extends _i4.PageRouteInfo<void> {
  const CustomScaffoldWithNavBar({List<_i4.PageRouteInfo>? children})
      : super(
          CustomScaffoldWithNavBar.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'CustomScaffoldWithNavBar';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class HomeRouter extends _i4.PageRouteInfo<void> {
  const HomeRouter({List<_i4.PageRouteInfo>? children})
      : super(
          HomeRouter.name,
          path: 'home',
          initialChildren: children,
        );

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i3.HomeScreen]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '',
        );

  static const String name = 'HomeRoute';
}
