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
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:auto_route/empty_router_widgets.dart' as _i2;
import 'package:flutter/material.dart' as _i7;

import '../data/models/sections/circuits/circuit_model.dart' as _i8;
import '../presentation/sections/circuits/circuits_screen.dart' as _i4;
import '../presentation/sections/circuits/sections/circuit/circuit_screen.dart'
    as _i5;
import '../presentation/sections/home/home_screen.dart' as _i3;
import '../presentation/widgets/scaffold_with_navbar.dart' as _i1;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    CustomScaffoldWithNavBar.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.CustomScaffoldWithNavBar(),
      );
    },
    HomeRouter.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
        maintainState: false,
      );
    },
    CircuitsRouter.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
        maintainState: false,
      );
    },
    HomeRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.HomeScreen(),
      );
    },
    CircuitsRoute.name: (routeData) {
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.CircuitsScreen(),
      );
    },
    CircuitRoute.name: (routeData) {
      final args = routeData.argsAs<CircuitRouteArgs>();
      return _i6.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.CircuitScreen(
          circuitModel: args.circuitModel,
          key: args.key,
        ),
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          CustomScaffoldWithNavBar.name,
          path: '/',
          children: [
            _i6.RouteConfig(
              HomeRouter.name,
              path: 'home',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i6.RouteConfig(
                  HomeRoute.name,
                  path: '',
                  parent: HomeRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                )
              ],
            ),
            _i6.RouteConfig(
              CircuitsRouter.name,
              path: 'circuits',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i6.RouteConfig(
                  CircuitsRoute.name,
                  path: '',
                  parent: CircuitsRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
                _i6.RouteConfig(
                  CircuitRoute.name,
                  path: 'circuit',
                  parent: CircuitsRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
              ],
            ),
          ],
        )
      ];
}

/// generated route for
/// [_i1.CustomScaffoldWithNavBar]
class CustomScaffoldWithNavBar extends _i6.PageRouteInfo<void> {
  const CustomScaffoldWithNavBar({List<_i6.PageRouteInfo>? children})
      : super(
          CustomScaffoldWithNavBar.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'CustomScaffoldWithNavBar';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class HomeRouter extends _i6.PageRouteInfo<void> {
  const HomeRouter({List<_i6.PageRouteInfo>? children})
      : super(
          HomeRouter.name,
          path: 'home',
          initialChildren: children,
        );

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class CircuitsRouter extends _i6.PageRouteInfo<void> {
  const CircuitsRouter({List<_i6.PageRouteInfo>? children})
      : super(
          CircuitsRouter.name,
          path: 'circuits',
          initialChildren: children,
        );

  static const String name = 'CircuitsRouter';
}

/// generated route for
/// [_i3.HomeScreen]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i4.CircuitsScreen]
class CircuitsRoute extends _i6.PageRouteInfo<void> {
  const CircuitsRoute()
      : super(
          CircuitsRoute.name,
          path: '',
        );

  static const String name = 'CircuitsRoute';
}

/// generated route for
/// [_i5.CircuitScreen]
class CircuitRoute extends _i6.PageRouteInfo<CircuitRouteArgs> {
  CircuitRoute({
    required _i8.CircuitModel circuitModel,
    _i7.Key? key,
  }) : super(
          CircuitRoute.name,
          path: 'circuit',
          args: CircuitRouteArgs(
            circuitModel: circuitModel,
            key: key,
          ),
        );

  static const String name = 'CircuitRoute';
}

class CircuitRouteArgs {
  const CircuitRouteArgs({
    required this.circuitModel,
    this.key,
  });

  final _i8.CircuitModel circuitModel;

  final _i7.Key? key;

  @override
  String toString() {
    return 'CircuitRouteArgs{circuitModel: $circuitModel, key: $key}';
  }
}
