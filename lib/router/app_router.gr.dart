// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i13;
import 'package:collection/collection.dart' as _i18;
import 'package:f1_pet_project/common/widgets/scaffold_with_navbar_screen.dart'
    as _i11;
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart' as _i14;
import 'package:f1_pet_project/core/circuits/screens/circuit_screen.dart'
    as _i1;
import 'package:f1_pet_project/core/circuits/screens/circuits_screen.dart'
    as _i3;
import 'package:f1_pet_project/core/constructor/screens/constructor_screen.dart'
    as _i4;
import 'package:f1_pet_project/core/driver/screens/driver_screen.dart' as _i5;
import 'package:f1_pet_project/core/hall_of_fame/screens/hall_of_fame_screen.dart'
    as _i6;
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart'
    as _i16;
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart'
    as _i17;
import 'package:f1_pet_project/core/home/screens/home_screen.dart' as _i7;
import 'package:f1_pet_project/core/results/race_info/screens/race_info_screen.dart'
    as _i8;
import 'package:f1_pet_project/core/results/race_search/screens/race_search_screen.dart'
    as _i9;
import 'package:f1_pet_project/core/results/screens/results_screen.dart'
    as _i10;
import 'package:f1_pet_project/core/schedule/models/races_model.dart' as _i19;
import 'package:f1_pet_project/core/schedule/screens/schedule_screen.dart'
    as _i12;
import 'package:f1_pet_project/router/empty_route_screens.dart' as _i2;
import 'package:flutter/material.dart' as _i15;

/// generated route for
/// [_i1.CircuitScreen]
class CircuitRoute extends _i13.PageRouteInfo<CircuitRouteArgs> {
  CircuitRoute({
    required _i14.CircuitModel circuitModel,
    _i15.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         CircuitRoute.name,
         args: CircuitRouteArgs(circuitModel: circuitModel, key: key),
         initialChildren: children,
       );

  static const String name = 'CircuitRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CircuitRouteArgs>();
      return _i1.CircuitScreen(circuitModel: args.circuitModel, key: args.key);
    },
  );
}

class CircuitRouteArgs {
  const CircuitRouteArgs({required this.circuitModel, this.key});

  final _i14.CircuitModel circuitModel;

  final _i15.Key? key;

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
class CircuitsRouter extends _i13.PageRouteInfo<void> {
  const CircuitsRouter({List<_i13.PageRouteInfo>? children})
    : super(CircuitsRouter.name, initialChildren: children);

  static const String name = 'CircuitsRouter';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.CircuitsRouterScreen();
    },
  );
}

/// generated route for
/// [_i3.CircuitsScreen]
class CircuitsRoute extends _i13.PageRouteInfo<void> {
  const CircuitsRoute({List<_i13.PageRouteInfo>? children})
    : super(CircuitsRoute.name, initialChildren: children);

  static const String name = 'CircuitsRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i3.CircuitsScreen();
    },
  );
}

/// generated route for
/// [_i4.ConstructorScreen]
class ConstructorRoute extends _i13.PageRouteInfo<ConstructorRouteArgs> {
  ConstructorRoute({
    required _i16.ConstructorModel constructor,
    List<_i17.DriverModel> currentDrivers = const [],
    _i15.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         ConstructorRoute.name,
         args: ConstructorRouteArgs(
           constructor: constructor,
           currentDrivers: currentDrivers,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'ConstructorRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ConstructorRouteArgs>();
      return _i4.ConstructorScreen(
        constructor: args.constructor,
        currentDrivers: args.currentDrivers,
        key: args.key,
      );
    },
  );
}

class ConstructorRouteArgs {
  const ConstructorRouteArgs({
    required this.constructor,
    this.currentDrivers = const [],
    this.key,
  });

  final _i16.ConstructorModel constructor;

  final List<_i17.DriverModel> currentDrivers;

  final _i15.Key? key;

  @override
  String toString() {
    return 'ConstructorRouteArgs{constructor: $constructor, currentDrivers: $currentDrivers, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ConstructorRouteArgs) return false;
    return constructor == other.constructor &&
        const _i18.ListEquality<_i17.DriverModel>().equals(
          currentDrivers,
          other.currentDrivers,
        ) &&
        key == other.key;
  }

  @override
  int get hashCode =>
      constructor.hashCode ^
      const _i18.ListEquality<_i17.DriverModel>().hash(currentDrivers) ^
      key.hashCode;
}

/// generated route for
/// [_i5.DriverScreen]
class DriverRoute extends _i13.PageRouteInfo<DriverRouteArgs> {
  DriverRoute({
    required _i17.DriverModel driver,
    List<_i16.ConstructorModel> currentConstructors = const [],
    _i15.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         DriverRoute.name,
         args: DriverRouteArgs(
           driver: driver,
           currentConstructors: currentConstructors,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'DriverRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DriverRouteArgs>();
      return _i5.DriverScreen(
        driver: args.driver,
        currentConstructors: args.currentConstructors,
        key: args.key,
      );
    },
  );
}

class DriverRouteArgs {
  const DriverRouteArgs({
    required this.driver,
    this.currentConstructors = const [],
    this.key,
  });

  final _i17.DriverModel driver;

  final List<_i16.ConstructorModel> currentConstructors;

  final _i15.Key? key;

  @override
  String toString() {
    return 'DriverRouteArgs{driver: $driver, currentConstructors: $currentConstructors, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriverRouteArgs) return false;
    return driver == other.driver &&
        const _i18.ListEquality<_i16.ConstructorModel>().equals(
          currentConstructors,
          other.currentConstructors,
        ) &&
        key == other.key;
  }

  @override
  int get hashCode =>
      driver.hashCode ^
      const _i18.ListEquality<_i16.ConstructorModel>().hash(
        currentConstructors,
      ) ^
      key.hashCode;
}

/// generated route for
/// [_i2.HallOfFameRouterScreen]
class HallOfFameRouter extends _i13.PageRouteInfo<void> {
  const HallOfFameRouter({List<_i13.PageRouteInfo>? children})
    : super(HallOfFameRouter.name, initialChildren: children);

  static const String name = 'HallOfFameRouter';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.HallOfFameRouterScreen();
    },
  );
}

/// generated route for
/// [_i6.HallOfFameScreen]
class HallOfFameRoute extends _i13.PageRouteInfo<void> {
  const HallOfFameRoute({List<_i13.PageRouteInfo>? children})
    : super(HallOfFameRoute.name, initialChildren: children);

  static const String name = 'HallOfFameRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i6.HallOfFameScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeRouterScreen]
class HomeRouter extends _i13.PageRouteInfo<void> {
  const HomeRouter({List<_i13.PageRouteInfo>? children})
    : super(HomeRouter.name, initialChildren: children);

  static const String name = 'HomeRouter';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeRouterScreen();
    },
  );
}

/// generated route for
/// [_i7.HomeScreen]
class HomeRoute extends _i13.PageRouteInfo<void> {
  const HomeRoute({List<_i13.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i7.HomeScreen();
    },
  );
}

/// generated route for
/// [_i8.RaceInfoScreen]
class RaceInfoRoute extends _i13.PageRouteInfo<RaceInfoRouteArgs> {
  RaceInfoRoute({
    required _i19.RacesModel raceModel,
    _i15.Key? key,
    List<_i13.PageRouteInfo>? children,
  }) : super(
         RaceInfoRoute.name,
         args: RaceInfoRouteArgs(raceModel: raceModel, key: key),
         initialChildren: children,
       );

  static const String name = 'RaceInfoRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RaceInfoRouteArgs>();
      return _i8.RaceInfoScreen(raceModel: args.raceModel, key: args.key);
    },
  );
}

class RaceInfoRouteArgs {
  const RaceInfoRouteArgs({required this.raceModel, this.key});

  final _i19.RacesModel raceModel;

  final _i15.Key? key;

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
/// [_i9.RaceSearchScreen]
class RaceSearchRoute extends _i13.PageRouteInfo<void> {
  const RaceSearchRoute({List<_i13.PageRouteInfo>? children})
    : super(RaceSearchRoute.name, initialChildren: children);

  static const String name = 'RaceSearchRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i9.RaceSearchScreen();
    },
  );
}

/// generated route for
/// [_i2.ResultsRouterScreen]
class ResultsRouter extends _i13.PageRouteInfo<void> {
  const ResultsRouter({List<_i13.PageRouteInfo>? children})
    : super(ResultsRouter.name, initialChildren: children);

  static const String name = 'ResultsRouter';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.ResultsRouterScreen();
    },
  );
}

/// generated route for
/// [_i10.ResultsScreen]
class ResultsRoute extends _i13.PageRouteInfo<void> {
  const ResultsRoute({List<_i13.PageRouteInfo>? children})
    : super(ResultsRoute.name, initialChildren: children);

  static const String name = 'ResultsRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i10.ResultsScreen();
    },
  );
}

/// generated route for
/// [_i11.ScaffoldWithNavBarScreen]
class ScaffoldWithNavBarRoute extends _i13.PageRouteInfo<void> {
  const ScaffoldWithNavBarRoute({List<_i13.PageRouteInfo>? children})
    : super(ScaffoldWithNavBarRoute.name, initialChildren: children);

  static const String name = 'ScaffoldWithNavBarRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i11.ScaffoldWithNavBarScreen();
    },
  );
}

/// generated route for
/// [_i2.ScheduleRouterScreen]
class ScheduleRouter extends _i13.PageRouteInfo<void> {
  const ScheduleRouter({List<_i13.PageRouteInfo>? children})
    : super(ScheduleRouter.name, initialChildren: children);

  static const String name = 'ScheduleRouter';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i2.ScheduleRouterScreen();
    },
  );
}

/// generated route for
/// [_i12.ScheduleScreen]
class ScheduleRoute extends _i13.PageRouteInfo<void> {
  const ScheduleRoute({List<_i13.PageRouteInfo>? children})
    : super(ScheduleRoute.name, initialChildren: children);

  static const String name = 'ScheduleRoute';

  static _i13.PageInfo page = _i13.PageInfo(
    name,
    builder: (data) {
      return const _i12.ScheduleScreen();
    },
  );
}
