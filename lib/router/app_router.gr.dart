// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:f1_pet_project/common/widgets/scaffold_with_navbar_screen.dart'
    as _i10;
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart' as _i13;
import 'package:f1_pet_project/core/circuits/screens/circuit_screen.dart'
    as _i1;
import 'package:f1_pet_project/core/circuits/screens/circuits_screen.dart'
    as _i3;
import 'package:f1_pet_project/core/driver/screens/driver_screen.dart' as _i4;
import 'package:f1_pet_project/core/hall_of_fame/screens/hall_of_fame_screen.dart'
    as _i5;
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart'
    as _i15;
import 'package:f1_pet_project/core/home/screens/home_screen.dart' as _i6;
import 'package:f1_pet_project/core/results/race_info/screens/race_info_screen.dart'
    as _i7;
import 'package:f1_pet_project/core/results/race_search/screens/race_search_screen.dart'
    as _i8;
import 'package:f1_pet_project/core/results/screens/results_screen.dart' as _i9;
import 'package:f1_pet_project/core/schedule/models/races_model.dart' as _i16;
import 'package:f1_pet_project/core/schedule/screens/schedule_screen.dart'
    as _i11;
import 'package:f1_pet_project/router/empty_route_screens.dart' as _i2;
import 'package:flutter/material.dart' as _i14;

/// generated route for
/// [_i1.CircuitScreen]
class CircuitRoute extends _i12.PageRouteInfo<CircuitRouteArgs> {
  CircuitRoute({
    required _i13.CircuitModel circuitModel,
    _i14.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         CircuitRoute.name,
         args: CircuitRouteArgs(circuitModel: circuitModel, key: key),
         initialChildren: children,
       );

  static const String name = 'CircuitRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CircuitRouteArgs>();
      return _i1.CircuitScreen(circuitModel: args.circuitModel, key: args.key);
    },
  );
}

class CircuitRouteArgs {
  const CircuitRouteArgs({required this.circuitModel, this.key});

  final _i13.CircuitModel circuitModel;

  final _i14.Key? key;

  @override
  String toString() {
    return 'CircuitRouteArgs{circuitModel: $circuitModel, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CircuitRouteArgs) return false;
    return circuitModel == other.circuitModel && key == other.key;
  }

  @override
  int get hashCode => circuitModel.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i2.CircuitsRouterScreen]
class CircuitsRouter extends _i12.PageRouteInfo<void> {
  const CircuitsRouter({List<_i12.PageRouteInfo>? children})
    : super(CircuitsRouter.name, initialChildren: children);

  static const String name = 'CircuitsRouter';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.CircuitsRouterScreen();
    },
  );
}

/// generated route for
/// [_i3.CircuitsScreen]
class CircuitsRoute extends _i12.PageRouteInfo<void> {
  const CircuitsRoute({List<_i12.PageRouteInfo>? children})
    : super(CircuitsRoute.name, initialChildren: children);

  static const String name = 'CircuitsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i3.CircuitsScreen();
    },
  );
}

/// generated route for
/// [_i4.DriverScreen]
class DriverRoute extends _i12.PageRouteInfo<DriverRouteArgs> {
  DriverRoute({
    required _i15.DriverModel driver,
    _i14.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         DriverRoute.name,
         args: DriverRouteArgs(driver: driver, key: key),
         initialChildren: children,
       );

  static const String name = 'DriverRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DriverRouteArgs>();
      return _i4.DriverScreen(driver: args.driver, key: args.key);
    },
  );
}

class DriverRouteArgs {
  const DriverRouteArgs({required this.driver, this.key});

  final _i15.DriverModel driver;

  final _i14.Key? key;

  @override
  String toString() {
    return 'DriverRouteArgs{driver: $driver, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriverRouteArgs) return false;
    return driver == other.driver && key == other.key;
  }

  @override
  int get hashCode => driver.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i2.HallOfFameRouterScreen]
class HallOfFameRouter extends _i12.PageRouteInfo<void> {
  const HallOfFameRouter({List<_i12.PageRouteInfo>? children})
    : super(HallOfFameRouter.name, initialChildren: children);

  static const String name = 'HallOfFameRouter';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.HallOfFameRouterScreen();
    },
  );
}

/// generated route for
/// [_i5.HallOfFameScreen]
class HallOfFameRoute extends _i12.PageRouteInfo<void> {
  const HallOfFameRoute({List<_i12.PageRouteInfo>? children})
    : super(HallOfFameRoute.name, initialChildren: children);

  static const String name = 'HallOfFameRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i5.HallOfFameScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeRouterScreen]
class HomeRouter extends _i12.PageRouteInfo<void> {
  const HomeRouter({List<_i12.PageRouteInfo>? children})
    : super(HomeRouter.name, initialChildren: children);

  static const String name = 'HomeRouter';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeRouterScreen();
    },
  );
}

/// generated route for
/// [_i6.HomeScreen]
class HomeRoute extends _i12.PageRouteInfo<void> {
  const HomeRoute({List<_i12.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.HomeScreen();
    },
  );
}

/// generated route for
/// [_i7.RaceInfoScreen]
class RaceInfoRoute extends _i12.PageRouteInfo<RaceInfoRouteArgs> {
  RaceInfoRoute({
    required _i16.RacesModel raceModel,
    _i14.Key? key,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         RaceInfoRoute.name,
         args: RaceInfoRouteArgs(raceModel: raceModel, key: key),
         initialChildren: children,
       );

  static const String name = 'RaceInfoRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RaceInfoRouteArgs>();
      return _i7.RaceInfoScreen(raceModel: args.raceModel, key: args.key);
    },
  );
}

class RaceInfoRouteArgs {
  const RaceInfoRouteArgs({required this.raceModel, this.key});

  final _i16.RacesModel raceModel;

  final _i14.Key? key;

  @override
  String toString() {
    return 'RaceInfoRouteArgs{raceModel: $raceModel, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RaceInfoRouteArgs) return false;
    return raceModel == other.raceModel && key == other.key;
  }

  @override
  int get hashCode => raceModel.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i8.RaceSearchScreen]
class RaceSearchRoute extends _i12.PageRouteInfo<void> {
  const RaceSearchRoute({List<_i12.PageRouteInfo>? children})
    : super(RaceSearchRoute.name, initialChildren: children);

  static const String name = 'RaceSearchRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i8.RaceSearchScreen();
    },
  );
}

/// generated route for
/// [_i2.ResultsRouterScreen]
class ResultsRouter extends _i12.PageRouteInfo<void> {
  const ResultsRouter({List<_i12.PageRouteInfo>? children})
    : super(ResultsRouter.name, initialChildren: children);

  static const String name = 'ResultsRouter';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.ResultsRouterScreen();
    },
  );
}

/// generated route for
/// [_i9.ResultsScreen]
class ResultsRoute extends _i12.PageRouteInfo<void> {
  const ResultsRoute({List<_i12.PageRouteInfo>? children})
    : super(ResultsRoute.name, initialChildren: children);

  static const String name = 'ResultsRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.ResultsScreen();
    },
  );
}

/// generated route for
/// [_i10.ScaffoldWithNavBarScreen]
class ScaffoldWithNavBarRoute extends _i12.PageRouteInfo<void> {
  const ScaffoldWithNavBarRoute({List<_i12.PageRouteInfo>? children})
    : super(ScaffoldWithNavBarRoute.name, initialChildren: children);

  static const String name = 'ScaffoldWithNavBarRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i10.ScaffoldWithNavBarScreen();
    },
  );
}

/// generated route for
/// [_i2.ScheduleRouterScreen]
class ScheduleRouter extends _i12.PageRouteInfo<void> {
  const ScheduleRouter({List<_i12.PageRouteInfo>? children})
    : super(ScheduleRouter.name, initialChildren: children);

  static const String name = 'ScheduleRouter';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i2.ScheduleRouterScreen();
    },
  );
}

/// generated route for
/// [_i11.ScheduleScreen]
class ScheduleRoute extends _i12.PageRouteInfo<void> {
  const ScheduleRoute({List<_i12.PageRouteInfo>? children})
    : super(ScheduleRoute.name, initialChildren: children);

  static const String name = 'ScheduleRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i11.ScheduleScreen();
    },
  );
}
