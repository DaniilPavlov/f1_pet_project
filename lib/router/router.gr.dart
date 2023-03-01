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
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:auto_route/empty_router_widgets.dart' as _i2;
import 'package:flutter/material.dart' as _i10;

import '../data/models/sections/circuits/circuit_model.dart' as _i12;
import '../data/models/sections/home/standings/standings_lists_model.dart'
    as _i11;
import '../presentation/sections/circuits/circuits_screen.dart' as _i7;
import '../presentation/sections/circuits/sections/circuit/circuit_screen.dart'
    as _i8;
import '../presentation/sections/hall_of_fame/champions/constructors/constructors_champions_screen.dart'
    as _i6;
import '../presentation/sections/hall_of_fame/champions/drivers/drivers_champions_screen.dart'
    as _i5;
import '../presentation/sections/hall_of_fame/hall_of_fame_screen.dart' as _i4;
import '../presentation/sections/home/home_screen.dart' as _i3;
import '../presentation/widgets/scaffold_with_navbar.dart' as _i1;

class AppRouter extends _i9.RootStackRouter {
  AppRouter([_i10.GlobalKey<_i10.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    CustomScaffoldWithNavBar.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.CustomScaffoldWithNavBar(),
      );
    },
    HomeRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
        maintainState: false,
      );
    },
    HallOfFameRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
        maintainState: false,
      );
    },
    CircuitsRouter.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
        maintainState: false,
      );
    },
    HomeRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.HomeScreen(),
      );
    },
    HallOfFameRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.HallOfFameScreen(),
      );
    },
    DriversChampionsRoute.name: (routeData) {
      final args = routeData.argsAs<DriversChampionsRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.DriversChampionsScreen(
          driversChampions: args.driversChampions,
          key: args.key,
        ),
      );
    },
    ConstructorsChampionsRoute.name: (routeData) {
      final args = routeData.argsAs<ConstructorsChampionsRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i6.ConstructorsChampionsScreen(
          constructorsChampions: args.constructorsChampions,
          key: args.key,
        ),
      );
    },
    CircuitsRoute.name: (routeData) {
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.CircuitsScreen(),
      );
    },
    CircuitRoute.name: (routeData) {
      final args = routeData.argsAs<CircuitRouteArgs>();
      return _i9.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i8.CircuitScreen(
          circuitModel: args.circuitModel,
          key: args.key,
        ),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          CustomScaffoldWithNavBar.name,
          path: '/',
          children: [
            _i9.RouteConfig(
              HomeRouter.name,
              path: 'home',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i9.RouteConfig(
                  HomeRoute.name,
                  path: '',
                  parent: HomeRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                )
              ],
            ),
            _i9.RouteConfig(
              HallOfFameRouter.name,
              path: 'hall_of_fame',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i9.RouteConfig(
                  HallOfFameRoute.name,
                  path: '',
                  parent: HallOfFameRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
                _i9.RouteConfig(
                  DriversChampionsRoute.name,
                  path: 'drivers_champions',
                  parent: HallOfFameRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
                _i9.RouteConfig(
                  ConstructorsChampionsRoute.name,
                  path: 'constructors_champions',
                  parent: HallOfFameRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
              ],
            ),
            _i9.RouteConfig(
              CircuitsRouter.name,
              path: 'circuits',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i9.RouteConfig(
                  CircuitsRoute.name,
                  path: '',
                  parent: CircuitsRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
                _i9.RouteConfig(
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
class CustomScaffoldWithNavBar extends _i9.PageRouteInfo<void> {
  const CustomScaffoldWithNavBar({List<_i9.PageRouteInfo>? children})
      : super(
          CustomScaffoldWithNavBar.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'CustomScaffoldWithNavBar';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class HomeRouter extends _i9.PageRouteInfo<void> {
  const HomeRouter({List<_i9.PageRouteInfo>? children})
      : super(
          HomeRouter.name,
          path: 'home',
          initialChildren: children,
        );

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class HallOfFameRouter extends _i9.PageRouteInfo<void> {
  const HallOfFameRouter({List<_i9.PageRouteInfo>? children})
      : super(
          HallOfFameRouter.name,
          path: 'hall_of_fame',
          initialChildren: children,
        );

  static const String name = 'HallOfFameRouter';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class CircuitsRouter extends _i9.PageRouteInfo<void> {
  const CircuitsRouter({List<_i9.PageRouteInfo>? children})
      : super(
          CircuitsRouter.name,
          path: 'circuits',
          initialChildren: children,
        );

  static const String name = 'CircuitsRouter';
}

/// generated route for
/// [_i3.HomeScreen]
class HomeRoute extends _i9.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i4.HallOfFameScreen]
class HallOfFameRoute extends _i9.PageRouteInfo<void> {
  const HallOfFameRoute()
      : super(
          HallOfFameRoute.name,
          path: '',
        );

  static const String name = 'HallOfFameRoute';
}

/// generated route for
/// [_i5.DriversChampionsScreen]
class DriversChampionsRoute
    extends _i9.PageRouteInfo<DriversChampionsRouteArgs> {
  DriversChampionsRoute({
    required List<_i11.StandingsListsModel> driversChampions,
    _i10.Key? key,
  }) : super(
          DriversChampionsRoute.name,
          path: 'drivers_champions',
          args: DriversChampionsRouteArgs(
            driversChampions: driversChampions,
            key: key,
          ),
        );

  static const String name = 'DriversChampionsRoute';
}

class DriversChampionsRouteArgs {
  const DriversChampionsRouteArgs({
    required this.driversChampions,
    this.key,
  });

  final List<_i11.StandingsListsModel> driversChampions;

  final _i10.Key? key;

  @override
  String toString() {
    return 'DriversChampionsRouteArgs{driversChampions: $driversChampions, key: $key}';
  }
}

/// generated route for
/// [_i6.ConstructorsChampionsScreen]
class ConstructorsChampionsRoute
    extends _i9.PageRouteInfo<ConstructorsChampionsRouteArgs> {
  ConstructorsChampionsRoute({
    required List<_i11.StandingsListsModel> constructorsChampions,
    _i10.Key? key,
  }) : super(
          ConstructorsChampionsRoute.name,
          path: 'constructors_champions',
          args: ConstructorsChampionsRouteArgs(
            constructorsChampions: constructorsChampions,
            key: key,
          ),
        );

  static const String name = 'ConstructorsChampionsRoute';
}

class ConstructorsChampionsRouteArgs {
  const ConstructorsChampionsRouteArgs({
    required this.constructorsChampions,
    this.key,
  });

  final List<_i11.StandingsListsModel> constructorsChampions;

  final _i10.Key? key;

  @override
  String toString() {
    return 'ConstructorsChampionsRouteArgs{constructorsChampions: $constructorsChampions, key: $key}';
  }
}

/// generated route for
/// [_i7.CircuitsScreen]
class CircuitsRoute extends _i9.PageRouteInfo<void> {
  const CircuitsRoute()
      : super(
          CircuitsRoute.name,
          path: '',
        );

  static const String name = 'CircuitsRoute';
}

/// generated route for
/// [_i8.CircuitScreen]
class CircuitRoute extends _i9.PageRouteInfo<CircuitRouteArgs> {
  CircuitRoute({
    required _i12.CircuitModel circuitModel,
    _i10.Key? key,
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

  final _i12.CircuitModel circuitModel;

  final _i10.Key? key;

  @override
  String toString() {
    return 'CircuitRouteArgs{circuitModel: $circuitModel, key: $key}';
  }
}
