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
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:auto_route/empty_router_widgets.dart' as _i2;
import 'package:flutter/material.dart' as _i14;

import '../data/models/sections/circuits/circuit_model.dart' as _i17;
import '../data/models/sections/home/standings/standings_lists_model.dart'
    as _i16;
import '../data/models/sections/results/results_model.dart' as _i15;
import '../presentation/sections/circuits/circuit/circuit_screen.dart' as _i12;
import '../presentation/sections/circuits/circuits_screen.dart' as _i11;
import '../presentation/sections/hall_of_fame/constructors_champions/constructors_champions_screen.dart'
    as _i10;
import '../presentation/sections/hall_of_fame/drivers_champions/drivers_champions_screen.dart'
    as _i9;
import '../presentation/sections/hall_of_fame/hall_of_fame_screen.dart' as _i8;
import '../presentation/sections/home/home_screen.dart' as _i3;
import '../presentation/sections/results/race_info/race_info_screen.dart'
    as _i5;
import '../presentation/sections/results/race_search/race_search_screen.dart'
    as _i6;
import '../presentation/sections/results/results_screen.dart' as _i4;
import '../presentation/sections/schedule/schedule_screen.dart' as _i7;
import '../presentation/widgets/scaffold_with_navbar.dart' as _i1;

class AppRouter extends _i13.RootStackRouter {
  AppRouter([_i14.GlobalKey<_i14.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    CustomScaffoldWithNavBar.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.CustomScaffoldWithNavBar(),
      );
    },
    HomeRouter.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
      );
    },
    ResultsRouter.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
      );
    },
    ScheduleRouter.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
      );
    },
    HallOfFameRouter.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
      );
    },
    CircuitsRouter.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.EmptyRouterScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i3.HomeScreen(),
      );
    },
    ResultsRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.ResultsScreen(),
      );
    },
    RaceInfoRoute.name: (routeData) {
      final args = routeData.argsAs<RaceInfoRouteArgs>();
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i5.RaceInfoScreen(
          results: args.results,
          key: args.key,
        ),
      );
    },
    RaceSearchRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i6.RaceSearchScreen(),
      );
    },
    ScheduleRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i7.ScheduleScreen(),
      );
    },
    HallOfFameRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i8.HallOfFameScreen(),
      );
    },
    DriversChampionsRoute.name: (routeData) {
      final args = routeData.argsAs<DriversChampionsRouteArgs>();
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i9.DriversChampionsScreen(
          driversChampions: args.driversChampions,
          key: args.key,
        ),
      );
    },
    ConstructorsChampionsRoute.name: (routeData) {
      final args = routeData.argsAs<ConstructorsChampionsRouteArgs>();
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.ConstructorsChampionsScreen(
          constructorsChampions: args.constructorsChampions,
          key: args.key,
        ),
      );
    },
    CircuitsRoute.name: (routeData) {
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i11.CircuitsScreen(),
      );
    },
    CircuitRoute.name: (routeData) {
      final args = routeData.argsAs<CircuitRouteArgs>();
      return _i13.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i12.CircuitScreen(
          circuitModel: args.circuitModel,
          key: args.key,
        ),
      );
    },
  };

  @override
  List<_i13.RouteConfig> get routes => [
        _i13.RouteConfig(
          CustomScaffoldWithNavBar.name,
          path: '/',
          children: [
            _i13.RouteConfig(
              HomeRouter.name,
              path: 'home',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i13.RouteConfig(
                  HomeRoute.name,
                  path: '',
                  parent: HomeRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                )
              ],
            ),
            _i13.RouteConfig(
              ResultsRouter.name,
              path: 'results',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i13.RouteConfig(
                  ResultsRoute.name,
                  path: '',
                  parent: ResultsRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
                _i13.RouteConfig(
                  RaceInfoRoute.name,
                  path: 'race_info',
                  parent: ResultsRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
                _i13.RouteConfig(
                  RaceSearchRoute.name,
                  path: 'race_search',
                  parent: ResultsRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
              ],
            ),
            _i13.RouteConfig(
              ScheduleRouter.name,
              path: 'schedule',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i13.RouteConfig(
                  ScheduleRoute.name,
                  path: '',
                  parent: ScheduleRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                )
              ],
            ),
            _i13.RouteConfig(
              HallOfFameRouter.name,
              path: 'hall_of_fame',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i13.RouteConfig(
                  HallOfFameRoute.name,
                  path: '',
                  parent: HallOfFameRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
                _i13.RouteConfig(
                  DriversChampionsRoute.name,
                  path: 'drivers_champions',
                  parent: HallOfFameRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
                _i13.RouteConfig(
                  ConstructorsChampionsRoute.name,
                  path: 'constructors_champions',
                  parent: HallOfFameRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
              ],
            ),
            _i13.RouteConfig(
              CircuitsRouter.name,
              path: 'circuits',
              parent: CustomScaffoldWithNavBar.name,
              children: [
                _i13.RouteConfig(
                  CircuitsRoute.name,
                  path: '',
                  parent: CircuitsRouter.name,
                  meta: <String, dynamic>{'hideBottomNav': false},
                ),
                _i13.RouteConfig(
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
class CustomScaffoldWithNavBar extends _i13.PageRouteInfo<void> {
  const CustomScaffoldWithNavBar({List<_i13.PageRouteInfo>? children})
      : super(
          CustomScaffoldWithNavBar.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'CustomScaffoldWithNavBar';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class HomeRouter extends _i13.PageRouteInfo<void> {
  const HomeRouter({List<_i13.PageRouteInfo>? children})
      : super(
          HomeRouter.name,
          path: 'home',
          initialChildren: children,
        );

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class ResultsRouter extends _i13.PageRouteInfo<void> {
  const ResultsRouter({List<_i13.PageRouteInfo>? children})
      : super(
          ResultsRouter.name,
          path: 'results',
          initialChildren: children,
        );

  static const String name = 'ResultsRouter';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class ScheduleRouter extends _i13.PageRouteInfo<void> {
  const ScheduleRouter({List<_i13.PageRouteInfo>? children})
      : super(
          ScheduleRouter.name,
          path: 'schedule',
          initialChildren: children,
        );

  static const String name = 'ScheduleRouter';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class HallOfFameRouter extends _i13.PageRouteInfo<void> {
  const HallOfFameRouter({List<_i13.PageRouteInfo>? children})
      : super(
          HallOfFameRouter.name,
          path: 'hall_of_fame',
          initialChildren: children,
        );

  static const String name = 'HallOfFameRouter';
}

/// generated route for
/// [_i2.EmptyRouterScreen]
class CircuitsRouter extends _i13.PageRouteInfo<void> {
  const CircuitsRouter({List<_i13.PageRouteInfo>? children})
      : super(
          CircuitsRouter.name,
          path: 'circuits',
          initialChildren: children,
        );

  static const String name = 'CircuitsRouter';
}

/// generated route for
/// [_i3.HomeScreen]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i4.ResultsScreen]
class ResultsRoute extends _i13.PageRouteInfo<void> {
  const ResultsRoute()
      : super(
          ResultsRoute.name,
          path: '',
        );

  static const String name = 'ResultsRoute';
}

/// generated route for
/// [_i5.RaceInfoScreen]
class RaceInfoRoute extends _i13.PageRouteInfo<RaceInfoRouteArgs> {
  RaceInfoRoute({
    required List<_i15.ResultsModel> results,
    _i14.Key? key,
  }) : super(
          RaceInfoRoute.name,
          path: 'race_info',
          args: RaceInfoRouteArgs(
            results: results,
            key: key,
          ),
        );

  static const String name = 'RaceInfoRoute';
}

class RaceInfoRouteArgs {
  const RaceInfoRouteArgs({
    required this.results,
    this.key,
  });

  final List<_i15.ResultsModel> results;

  final _i14.Key? key;

  @override
  String toString() {
    return 'RaceInfoRouteArgs{results: $results, key: $key}';
  }
}

/// generated route for
/// [_i6.RaceSearchScreen]
class RaceSearchRoute extends _i13.PageRouteInfo<void> {
  const RaceSearchRoute()
      : super(
          RaceSearchRoute.name,
          path: 'race_search',
        );

  static const String name = 'RaceSearchRoute';
}

/// generated route for
/// [_i7.ScheduleScreen]
class ScheduleRoute extends _i13.PageRouteInfo<void> {
  const ScheduleRoute()
      : super(
          ScheduleRoute.name,
          path: '',
        );

  static const String name = 'ScheduleRoute';
}

/// generated route for
/// [_i8.HallOfFameScreen]
class HallOfFameRoute extends _i13.PageRouteInfo<void> {
  const HallOfFameRoute()
      : super(
          HallOfFameRoute.name,
          path: '',
        );

  static const String name = 'HallOfFameRoute';
}

/// generated route for
/// [_i9.DriversChampionsScreen]
class DriversChampionsRoute
    extends _i13.PageRouteInfo<DriversChampionsRouteArgs> {
  DriversChampionsRoute({
    required List<_i16.StandingsListsModel> driversChampions,
    _i14.Key? key,
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

  final List<_i16.StandingsListsModel> driversChampions;

  final _i14.Key? key;

  @override
  String toString() {
    return 'DriversChampionsRouteArgs{driversChampions: $driversChampions, key: $key}';
  }
}

/// generated route for
/// [_i10.ConstructorsChampionsScreen]
class ConstructorsChampionsRoute
    extends _i13.PageRouteInfo<ConstructorsChampionsRouteArgs> {
  ConstructorsChampionsRoute({
    required List<_i16.StandingsListsModel> constructorsChampions,
    _i14.Key? key,
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

  final List<_i16.StandingsListsModel> constructorsChampions;

  final _i14.Key? key;

  @override
  String toString() {
    return 'ConstructorsChampionsRouteArgs{constructorsChampions: $constructorsChampions, key: $key}';
  }
}

/// generated route for
/// [_i11.CircuitsScreen]
class CircuitsRoute extends _i13.PageRouteInfo<void> {
  const CircuitsRoute()
      : super(
          CircuitsRoute.name,
          path: '',
        );

  static const String name = 'CircuitsRoute';
}

/// generated route for
/// [_i12.CircuitScreen]
class CircuitRoute extends _i13.PageRouteInfo<CircuitRouteArgs> {
  CircuitRoute({
    required _i17.CircuitModel circuitModel,
    _i14.Key? key,
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

  final _i17.CircuitModel circuitModel;

  final _i14.Key? key;

  @override
  String toString() {
    return 'CircuitRouteArgs{circuitModel: $circuitModel, key: $key}';
  }
}
