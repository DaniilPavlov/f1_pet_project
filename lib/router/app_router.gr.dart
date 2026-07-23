// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:collection/collection.dart' as _i22;
import 'package:f1_pet_project/common/widgets/scaffold_with_navbar_screen.dart'
    as _i15;
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart' as _i18;
import 'package:f1_pet_project/core/circuits/screens/circuit_screen.dart'
    as _i1;
import 'package:f1_pet_project/core/circuits/screens/circuits_screen.dart'
    as _i3;
import 'package:f1_pet_project/core/home/screens/home_screen.dart' as _i10;
import 'package:f1_pet_project/core/news/screens/news_screen.dart' as _i11;
import 'package:f1_pet_project/core/results/constructor/screens/constructor_screen.dart'
    as _i4;
import 'package:f1_pet_project/core/results/driver/screens/driver_screen.dart'
    as _i5;
import 'package:f1_pet_project/core/results/finish_status/screens/finish_status_screen.dart'
    as _i6;
import 'package:f1_pet_project/core/results/h2h/screens/h2h_constructors_screen.dart'
    as _i7;
import 'package:f1_pet_project/core/results/h2h/screens/h2h_screen.dart' as _i8;
import 'package:f1_pet_project/core/results/hall_of_fame/screens/hall_of_fame_screen.dart'
    as _i9;
import 'package:f1_pet_project/core/results/race_info/screens/race_info_screen.dart'
    as _i12;
import 'package:f1_pet_project/core/results/race_search/screens/race_search_screen.dart'
    as _i13;
import 'package:f1_pet_project/core/results/screens/results_screen.dart'
    as _i14;
import 'package:f1_pet_project/core/schedule/models/races_model.dart' as _i23;
import 'package:f1_pet_project/core/schedule/screens/schedule_screen.dart'
    as _i16;
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart'
    as _i20;
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart'
    as _i21;
import 'package:f1_pet_project/router/nested_router_screens.dart' as _i2;
import 'package:flutter/material.dart' as _i19;

/// generated route for
/// [_i1.CircuitScreen]
class CircuitRoute extends _i17.PageRouteInfo<CircuitRouteArgs> {
  CircuitRoute({
    required _i18.CircuitModel circuitModel,
    _i19.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         CircuitRoute.name,
         args: CircuitRouteArgs(circuitModel: circuitModel, key: key),
         initialChildren: children,
       );

  static const String name = 'CircuitRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CircuitRouteArgs>();
      return _i1.CircuitScreen(circuitModel: args.circuitModel, key: args.key);
    },
  );
}

class CircuitRouteArgs {
  const CircuitRouteArgs({required this.circuitModel, this.key});

  final _i18.CircuitModel circuitModel;

  final _i19.Key? key;

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
class CircuitsRouter extends _i17.PageRouteInfo<void> {
  const CircuitsRouter({List<_i17.PageRouteInfo>? children})
    : super(CircuitsRouter.name, initialChildren: children);

  static const String name = 'CircuitsRouter';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.CircuitsRouterScreen();
    },
  );
}

/// generated route for
/// [_i3.CircuitsScreen]
class CircuitsRoute extends _i17.PageRouteInfo<void> {
  const CircuitsRoute({List<_i17.PageRouteInfo>? children})
    : super(CircuitsRoute.name, initialChildren: children);

  static const String name = 'CircuitsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i3.CircuitsScreen();
    },
  );
}

/// generated route for
/// [_i4.ConstructorScreen]
class ConstructorRoute extends _i17.PageRouteInfo<ConstructorRouteArgs> {
  ConstructorRoute({
    required _i20.ConstructorModel constructor,
    List<_i21.DriverModel> currentDrivers = const [],
    _i19.Key? key,
    List<_i17.PageRouteInfo>? children,
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

  static _i17.PageInfo page = _i17.PageInfo(
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

  final _i20.ConstructorModel constructor;

  final List<_i21.DriverModel> currentDrivers;

  final _i19.Key? key;

  @override
  String toString() {
    return 'ConstructorRouteArgs{constructor: $constructor, currentDrivers: $currentDrivers, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ConstructorRouteArgs) return false;
    return constructor == other.constructor &&
        const _i22.ListEquality<_i21.DriverModel>().equals(
          currentDrivers,
          other.currentDrivers,
        ) &&
        key == other.key;
  }

  @override
  int get hashCode =>
      constructor.hashCode ^
      const _i22.ListEquality<_i21.DriverModel>().hash(currentDrivers) ^
      key.hashCode;
}

/// generated route for
/// [_i5.DriverScreen]
class DriverRoute extends _i17.PageRouteInfo<DriverRouteArgs> {
  DriverRoute({
    required _i21.DriverModel driver,
    List<_i20.ConstructorModel> currentConstructors = const [],
    _i19.Key? key,
    List<_i17.PageRouteInfo>? children,
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

  static _i17.PageInfo page = _i17.PageInfo(
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

  final _i21.DriverModel driver;

  final List<_i20.ConstructorModel> currentConstructors;

  final _i19.Key? key;

  @override
  String toString() {
    return 'DriverRouteArgs{driver: $driver, currentConstructors: $currentConstructors, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriverRouteArgs) return false;
    return driver == other.driver &&
        const _i22.ListEquality<_i20.ConstructorModel>().equals(
          currentConstructors,
          other.currentConstructors,
        ) &&
        key == other.key;
  }

  @override
  int get hashCode =>
      driver.hashCode ^
      const _i22.ListEquality<_i20.ConstructorModel>().hash(
        currentConstructors,
      ) ^
      key.hashCode;
}

/// generated route for
/// [_i6.FinishStatusScreen]
class FinishStatusRoute extends _i17.PageRouteInfo<void> {
  const FinishStatusRoute({List<_i17.PageRouteInfo>? children})
    : super(FinishStatusRoute.name, initialChildren: children);

  static const String name = 'FinishStatusRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i6.FinishStatusScreen();
    },
  );
}

/// generated route for
/// [_i7.H2hConstructorsScreen]
class H2hConstructorsRoute extends _i17.PageRouteInfo<void> {
  const H2hConstructorsRoute({List<_i17.PageRouteInfo>? children})
    : super(H2hConstructorsRoute.name, initialChildren: children);

  static const String name = 'H2hConstructorsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i7.H2hConstructorsScreen();
    },
  );
}

/// generated route for
/// [_i8.H2hScreen]
class H2hRoute extends _i17.PageRouteInfo<void> {
  const H2hRoute({List<_i17.PageRouteInfo>? children})
    : super(H2hRoute.name, initialChildren: children);

  static const String name = 'H2hRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i8.H2hScreen();
    },
  );
}

/// generated route for
/// [_i9.HallOfFameScreen]
class HallOfFameRoute extends _i17.PageRouteInfo<void> {
  const HallOfFameRoute({List<_i17.PageRouteInfo>? children})
    : super(HallOfFameRoute.name, initialChildren: children);

  static const String name = 'HallOfFameRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i9.HallOfFameScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeRouterScreen]
class HomeRouter extends _i17.PageRouteInfo<void> {
  const HomeRouter({List<_i17.PageRouteInfo>? children})
    : super(HomeRouter.name, initialChildren: children);

  static const String name = 'HomeRouter';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeRouterScreen();
    },
  );
}

/// generated route for
/// [_i10.HomeScreen]
class HomeRoute extends _i17.PageRouteInfo<void> {
  const HomeRoute({List<_i17.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i10.HomeScreen();
    },
  );
}

/// generated route for
/// [_i2.NewsRouterScreen]
class NewsRouter extends _i17.PageRouteInfo<void> {
  const NewsRouter({List<_i17.PageRouteInfo>? children})
    : super(NewsRouter.name, initialChildren: children);

  static const String name = 'NewsRouter';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.NewsRouterScreen();
    },
  );
}

/// generated route for
/// [_i11.NewsScreen]
class NewsRoute extends _i17.PageRouteInfo<void> {
  const NewsRoute({List<_i17.PageRouteInfo>? children})
    : super(NewsRoute.name, initialChildren: children);

  static const String name = 'NewsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i11.NewsScreen();
    },
  );
}

/// generated route for
/// [_i12.RaceInfoScreen]
class RaceInfoRoute extends _i17.PageRouteInfo<RaceInfoRouteArgs> {
  RaceInfoRoute({
    required _i23.RacesModel raceModel,
    _i19.Key? key,
    List<_i17.PageRouteInfo>? children,
  }) : super(
         RaceInfoRoute.name,
         args: RaceInfoRouteArgs(raceModel: raceModel, key: key),
         initialChildren: children,
       );

  static const String name = 'RaceInfoRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RaceInfoRouteArgs>();
      return _i12.RaceInfoScreen(raceModel: args.raceModel, key: args.key);
    },
  );
}

class RaceInfoRouteArgs {
  const RaceInfoRouteArgs({required this.raceModel, this.key});

  final _i23.RacesModel raceModel;

  final _i19.Key? key;

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
/// [_i13.RaceSearchScreen]
class RaceSearchRoute extends _i17.PageRouteInfo<void> {
  const RaceSearchRoute({List<_i17.PageRouteInfo>? children})
    : super(RaceSearchRoute.name, initialChildren: children);

  static const String name = 'RaceSearchRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i13.RaceSearchScreen();
    },
  );
}

/// generated route for
/// [_i2.ResultsRouterScreen]
class ResultsRouter extends _i17.PageRouteInfo<void> {
  const ResultsRouter({List<_i17.PageRouteInfo>? children})
    : super(ResultsRouter.name, initialChildren: children);

  static const String name = 'ResultsRouter';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.ResultsRouterScreen();
    },
  );
}

/// generated route for
/// [_i14.ResultsScreen]
class ResultsRoute extends _i17.PageRouteInfo<void> {
  const ResultsRoute({List<_i17.PageRouteInfo>? children})
    : super(ResultsRoute.name, initialChildren: children);

  static const String name = 'ResultsRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i14.ResultsScreen();
    },
  );
}

/// generated route for
/// [_i15.ScaffoldWithNavBarScreen]
class ScaffoldWithNavBarRoute extends _i17.PageRouteInfo<void> {
  const ScaffoldWithNavBarRoute({List<_i17.PageRouteInfo>? children})
    : super(ScaffoldWithNavBarRoute.name, initialChildren: children);

  static const String name = 'ScaffoldWithNavBarRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i15.ScaffoldWithNavBarScreen();
    },
  );
}

/// generated route for
/// [_i2.ScheduleRouterScreen]
class ScheduleRouter extends _i17.PageRouteInfo<void> {
  const ScheduleRouter({List<_i17.PageRouteInfo>? children})
    : super(ScheduleRouter.name, initialChildren: children);

  static const String name = 'ScheduleRouter';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i2.ScheduleRouterScreen();
    },
  );
}

/// generated route for
/// [_i16.ScheduleScreen]
class ScheduleRoute extends _i17.PageRouteInfo<void> {
  const ScheduleRoute({List<_i17.PageRouteInfo>? children})
    : super(ScheduleRoute.name, initialChildren: children);

  static const String name = 'ScheduleRoute';

  static _i17.PageInfo page = _i17.PageInfo(
    name,
    builder: (data) {
      return const _i16.ScheduleScreen();
    },
  );
}
