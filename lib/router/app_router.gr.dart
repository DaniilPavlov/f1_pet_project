// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart'
    as _i12;
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart'
    as _i14;
import 'package:f1_pet_project/presentation/sections/circuits/circuit/circuit_screen.dart'
    as _i1;
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart'
    as _i3;
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart'
    as _i4;
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart'
    as _i5;
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_screen.dart'
    as _i6;
import 'package:f1_pet_project/presentation/sections/results/race_search/race_search_screen.dart'
    as _i7;
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart'
    as _i8;
import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart'
    as _i10;
import 'package:f1_pet_project/presentation/widgets/scaffold_with_navbar_screen.dart'
    as _i9;
import 'package:f1_pet_project/router/empty_route_screens.dart' as _i2;
import 'package:flutter/material.dart' as _i13;

/// generated route for
/// [_i1.CircuitScreen]
class CircuitRoute extends _i11.PageRouteInfo<CircuitRouteArgs> {
  CircuitRoute({
    required _i12.CircuitModel circuitModel,
    _i13.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          CircuitRoute.name,
          args: CircuitRouteArgs(circuitModel: circuitModel, key: key),
          initialChildren: children,
        );

  static const String name = 'CircuitRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CircuitRouteArgs>();
      return _i1.CircuitScreen(circuitModel: args.circuitModel, key: args.key);
    },
  );
}

class CircuitRouteArgs {
  const CircuitRouteArgs({required this.circuitModel, this.key});

  final _i12.CircuitModel circuitModel;

  final _i13.Key? key;

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
class CircuitsRouter extends _i11.PageRouteInfo<void> {
  const CircuitsRouter({List<_i11.PageRouteInfo>? children})
      : super(CircuitsRouter.name, initialChildren: children);

  static const String name = 'CircuitsRouter';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.CircuitsRouterScreen();
    },
  );
}

/// generated route for
/// [_i3.CircuitsScreen]
class CircuitsRoute extends _i11.PageRouteInfo<void> {
  const CircuitsRoute({List<_i11.PageRouteInfo>? children})
      : super(CircuitsRoute.name, initialChildren: children);

  static const String name = 'CircuitsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i3.CircuitsScreen();
    },
  );
}

/// generated route for
/// [_i2.HallOfFameRouterScreen]
class HallOfFameRouter extends _i11.PageRouteInfo<void> {
  const HallOfFameRouter({List<_i11.PageRouteInfo>? children})
      : super(HallOfFameRouter.name, initialChildren: children);

  static const String name = 'HallOfFameRouter';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.HallOfFameRouterScreen();
    },
  );
}

/// generated route for
/// [_i4.HallOfFameScreen]
class HallOfFameRoute extends _i11.PageRouteInfo<void> {
  const HallOfFameRoute({List<_i11.PageRouteInfo>? children})
      : super(HallOfFameRoute.name, initialChildren: children);

  static const String name = 'HallOfFameRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.HallOfFameScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeRouterScreen]
class HomeRouter extends _i11.PageRouteInfo<void> {
  const HomeRouter({List<_i11.PageRouteInfo>? children})
      : super(HomeRouter.name, initialChildren: children);

  static const String name = 'HomeRouter';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeRouterScreen();
    },
  );
}

/// generated route for
/// [_i5.HomeScreen]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
      : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i5.HomeScreen();
    },
  );
}

/// generated route for
/// [_i6.RaceInfoScreen]
class RaceInfoRoute extends _i11.PageRouteInfo<RaceInfoRouteArgs> {
  RaceInfoRoute({
    required _i14.RacesModel raceModel,
    _i13.Key? key,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          RaceInfoRoute.name,
          args: RaceInfoRouteArgs(raceModel: raceModel, key: key),
          initialChildren: children,
        );

  static const String name = 'RaceInfoRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RaceInfoRouteArgs>();
      return _i6.RaceInfoScreen(raceModel: args.raceModel, key: args.key);
    },
  );
}

class RaceInfoRouteArgs {
  const RaceInfoRouteArgs({required this.raceModel, this.key});

  final _i14.RacesModel raceModel;

  final _i13.Key? key;

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
/// [_i7.RaceSearchScreen]
class RaceSearchRoute extends _i11.PageRouteInfo<void> {
  const RaceSearchRoute({List<_i11.PageRouteInfo>? children})
      : super(RaceSearchRoute.name, initialChildren: children);

  static const String name = 'RaceSearchRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i7.RaceSearchScreen();
    },
  );
}

/// generated route for
/// [_i2.ResultsRouterScreen]
class ResultsRouter extends _i11.PageRouteInfo<void> {
  const ResultsRouter({List<_i11.PageRouteInfo>? children})
      : super(ResultsRouter.name, initialChildren: children);

  static const String name = 'ResultsRouter';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.ResultsRouterScreen();
    },
  );
}

/// generated route for
/// [_i8.ResultsScreen]
class ResultsRoute extends _i11.PageRouteInfo<void> {
  const ResultsRoute({List<_i11.PageRouteInfo>? children})
      : super(ResultsRoute.name, initialChildren: children);

  static const String name = 'ResultsRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i8.ResultsScreen();
    },
  );
}

/// generated route for
/// [_i9.ScaffoldWithNavBarScreen]
class ScaffoldWithNavBarRoute extends _i11.PageRouteInfo<void> {
  const ScaffoldWithNavBarRoute({List<_i11.PageRouteInfo>? children})
      : super(ScaffoldWithNavBarRoute.name, initialChildren: children);

  static const String name = 'ScaffoldWithNavBarRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i9.ScaffoldWithNavBarScreen();
    },
  );
}

/// generated route for
/// [_i2.ScheduleRouterScreen]
class ScheduleRouter extends _i11.PageRouteInfo<void> {
  const ScheduleRouter({List<_i11.PageRouteInfo>? children})
      : super(ScheduleRouter.name, initialChildren: children);

  static const String name = 'ScheduleRouter';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.ScheduleRouterScreen();
    },
  );
}

/// generated route for
/// [_i10.ScheduleScreen]
class ScheduleRoute extends _i11.PageRouteInfo<void> {
  const ScheduleRoute({List<_i11.PageRouteInfo>? children})
      : super(ScheduleRoute.name, initialChildren: children);

  static const String name = 'ScheduleRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i10.ScheduleScreen();
    },
  );
}
