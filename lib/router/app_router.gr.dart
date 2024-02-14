// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart'
    as _i14;
import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart'
    as _i16;
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart'
    as _i17;
import 'package:f1_pet_project/presentation/sections/circuits/circuit/circuit_screen.dart'
    as _i1;
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart'
    as _i3;
import 'package:f1_pet_project/presentation/sections/hall_of_fame/constructors_champions/constructors_champions_screen.dart'
    as _i4;
import 'package:f1_pet_project/presentation/sections/hall_of_fame/drivers_champions/drivers_champions_screen.dart'
    as _i5;
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart'
    as _i6;
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart'
    as _i7;
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_screen.dart'
    as _i8;
import 'package:f1_pet_project/presentation/sections/results/race_search/race_search_screen.dart'
    as _i9;
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart'
    as _i10;
import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart'
    as _i12;
import 'package:f1_pet_project/presentation/widgets/scaffold_with_navbar_screen.dart'
    as _i11;
import 'package:f1_pet_project/router/empty_route_screens.dart' as _i2;
import 'package:flutter/material.dart' as _i15;

abstract class $AppRouter extends _i13.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i13.PageFactory> pagesMap = {
    CircuitRoute.name: (routeData) {
      final args = routeData.argsAs<CircuitRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.CircuitScreen(
          circuitModel: args.circuitModel,
          key: args.key,
        ),
      );
    },
    CircuitsRouter.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.CircuitsRouterScreen(),
      );
    },
    CircuitsRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.CircuitsScreen(),
      );
    },
    ConstructorsChampionsRoute.name: (routeData) {
      final args = routeData.argsAs<ConstructorsChampionsRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.ConstructorsChampionsScreen(
          constructorsChampions: args.constructorsChampions,
          key: args.key,
        ),
      );
    },
    DriversChampionsRoute.name: (routeData) {
      final args = routeData.argsAs<DriversChampionsRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.DriversChampionsScreen(
          driversChampions: args.driversChampions,
          key: args.key,
        ),
      );
    },
    HallOfFameRouter.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HallOfFameRouterScreen(),
      );
    },
    HallOfFameRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.HallOfFameScreen(),
      );
    },
    HomeRouter.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeRouterScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.HomeScreen(),
      );
    },
    RaceInfoRoute.name: (routeData) {
      final args = routeData.argsAs<RaceInfoRouteArgs>();
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.RaceInfoScreen(
          raceModel: args.raceModel,
          key: args.key,
        ),
      );
    },
    RaceSearchRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.RaceSearchScreen(),
      );
    },
    ResultsRouter.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ResultsRouterScreen(),
      );
    },
    ResultsRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.ResultsScreen(),
      );
    },
    ScaffoldWithNavBarRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.ScaffoldWithNavBarScreen(),
      );
    },
    ScheduleRouter.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ScheduleRouterScreen(),
      );
    },
    ScheduleRoute.name: (routeData) {
      return _i13.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.ScheduleScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.CircuitScreen]
class CircuitRoute extends _i13.PageRouteInfo<CircuitRouteArgs> {
  CircuitRoute({
    required _i14.CircuitModel circuitModel,
    _i15.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          CircuitRoute.name,
          args: CircuitRouteArgs(
            circuitModel: circuitModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'CircuitRoute';

  static const _i13.PageInfo<CircuitRouteArgs> page =
      _i13.PageInfo<CircuitRouteArgs>(name);
}

class CircuitRouteArgs {
  const CircuitRouteArgs({
    required this.circuitModel,
    this.key,
  });

  final _i14.CircuitModel circuitModel;

  final _i15.Key? key;

  @override
  String toString() {
    return 'CircuitRouteArgs{circuitModel: $circuitModel, key: $key}';
  }
}

/// generated route for
/// [_i2.CircuitsRouterScreen]
class CircuitsRouter extends _i13.PageRouteInfo<void> {
  const CircuitsRouter({List<_i13.PageRouteInfo>? children})
      : super(
          CircuitsRouter.name,
          initialChildren: children,
        );

  static const String name = 'CircuitsRouter';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i3.CircuitsScreen]
class CircuitsRoute extends _i13.PageRouteInfo<void> {
  const CircuitsRoute({List<_i13.PageRouteInfo>? children})
      : super(
          CircuitsRoute.name,
          initialChildren: children,
        );

  static const String name = 'CircuitsRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i4.ConstructorsChampionsScreen]
class ConstructorsChampionsRoute
    extends _i13.PageRouteInfo<ConstructorsChampionsRouteArgs> {
  ConstructorsChampionsRoute({
    required List<_i16.StandingsListsModel> constructorsChampions,
    _i15.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          ConstructorsChampionsRoute.name,
          args: ConstructorsChampionsRouteArgs(
            constructorsChampions: constructorsChampions,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'ConstructorsChampionsRoute';

  static const _i13.PageInfo<ConstructorsChampionsRouteArgs> page =
      _i13.PageInfo<ConstructorsChampionsRouteArgs>(name);
}

class ConstructorsChampionsRouteArgs {
  const ConstructorsChampionsRouteArgs({
    required this.constructorsChampions,
    this.key,
  });

  final List<_i16.StandingsListsModel> constructorsChampions;

  final _i15.Key? key;

  @override
  String toString() {
    return 'ConstructorsChampionsRouteArgs{constructorsChampions: $constructorsChampions, key: $key}';
  }
}

/// generated route for
/// [_i5.DriversChampionsScreen]
class DriversChampionsRoute
    extends _i13.PageRouteInfo<DriversChampionsRouteArgs> {
  DriversChampionsRoute({
    required List<_i16.StandingsListsModel> driversChampions,
    _i15.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          DriversChampionsRoute.name,
          args: DriversChampionsRouteArgs(
            driversChampions: driversChampions,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'DriversChampionsRoute';

  static const _i13.PageInfo<DriversChampionsRouteArgs> page =
      _i13.PageInfo<DriversChampionsRouteArgs>(name);
}

class DriversChampionsRouteArgs {
  const DriversChampionsRouteArgs({
    required this.driversChampions,
    this.key,
  });

  final List<_i16.StandingsListsModel> driversChampions;

  final _i15.Key? key;

  @override
  String toString() {
    return 'DriversChampionsRouteArgs{driversChampions: $driversChampions, key: $key}';
  }
}

/// generated route for
/// [_i2.HallOfFameRouterScreen]
class HallOfFameRouter extends _i13.PageRouteInfo<void> {
  const HallOfFameRouter({List<_i13.PageRouteInfo>? children})
      : super(
          HallOfFameRouter.name,
          initialChildren: children,
        );

  static const String name = 'HallOfFameRouter';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i6.HallOfFameScreen]
class HallOfFameRoute extends _i13.PageRouteInfo<void> {
  const HallOfFameRoute({List<_i13.PageRouteInfo>? children})
      : super(
          HallOfFameRoute.name,
          initialChildren: children,
        );

  static const String name = 'HallOfFameRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HomeRouterScreen]
class HomeRouter extends _i13.PageRouteInfo<void> {
  const HomeRouter({List<_i13.PageRouteInfo>? children})
      : super(
          HomeRouter.name,
          initialChildren: children,
        );

  static const String name = 'HomeRouter';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i7.HomeScreen]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute({List<_i13.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i8.RaceInfoScreen]
class RaceInfoRoute extends _i13.PageRouteInfo<RaceInfoRouteArgs> {
  RaceInfoRoute({
    required _i17.RacesModel raceModel,
    _i15.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
          RaceInfoRoute.name,
          args: RaceInfoRouteArgs(
            raceModel: raceModel,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'RaceInfoRoute';

  static const _i13.PageInfo<RaceInfoRouteArgs> page =
      _i13.PageInfo<RaceInfoRouteArgs>(name);
}

class RaceInfoRouteArgs {
  const RaceInfoRouteArgs({
    required this.raceModel,
    this.key,
  });

  final _i17.RacesModel raceModel;

  final _i15.Key? key;

  @override
  String toString() {
    return 'RaceInfoRouteArgs{raceModel: $raceModel, key: $key}';
  }
}

/// generated route for
/// [_i9.RaceSearchScreen]
class RaceSearchRoute extends _i13.PageRouteInfo<void> {
  const RaceSearchRoute({List<_i13.PageRouteInfo>? children})
      : super(
          RaceSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'RaceSearchRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ResultsRouterScreen]
class ResultsRouter extends _i13.PageRouteInfo<void> {
  const ResultsRouter({List<_i13.PageRouteInfo>? children})
      : super(
          ResultsRouter.name,
          initialChildren: children,
        );

  static const String name = 'ResultsRouter';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i10.ResultsScreen]
class ResultsRoute extends _i13.PageRouteInfo<void> {
  const ResultsRoute({List<_i13.PageRouteInfo>? children})
      : super(
          ResultsRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResultsRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i11.ScaffoldWithNavBarScreen]
class ScaffoldWithNavBarRoute extends _i13.PageRouteInfo<void> {
  const ScaffoldWithNavBarRoute({List<_i13.PageRouteInfo>? children})
      : super(
          ScaffoldWithNavBarRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScaffoldWithNavBarRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ScheduleRouterScreen]
class ScheduleRouter extends _i13.PageRouteInfo<void> {
  const ScheduleRouter({List<_i13.PageRouteInfo>? children})
      : super(
          ScheduleRouter.name,
          initialChildren: children,
        );

  static const String name = 'ScheduleRouter';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}

/// generated route for
/// [_i12.ScheduleScreen]
class ScheduleRoute extends _i13.PageRouteInfo<void> {
  const ScheduleRoute({List<_i13.PageRouteInfo>? children})
      : super(
          ScheduleRoute.name,
          initialChildren: children,
        );

  static const String name = 'ScheduleRoute';

  static const _i13.PageInfo<void> page = _i13.PageInfo<void>(name);
}
