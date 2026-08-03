// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i23;
import 'package:collection/collection.dart' as _i28;
import 'package:f1_pet_project/common/widgets/scaffold_with_navbar_screen.dart'
    as _i20;
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart' as _i24;
import 'package:f1_pet_project/core/circuits/screens/circuit_screen.dart'
    as _i2;
import 'package:f1_pet_project/core/circuits/screens/circuits_screen.dart'
    as _i3;
import 'package:f1_pet_project/core/home/screens/home_screen.dart' as _i11;
import 'package:f1_pet_project/core/predictor/models/predictor_season.dart'
    as _i30;
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart'
    as _i31;
import 'package:f1_pet_project/core/predictor/screens/predictor_leaderboard_screen.dart'
    as _i12;
import 'package:f1_pet_project/core/predictor/screens/predictor_screen.dart'
    as _i13;
import 'package:f1_pet_project/core/predictor/screens/predictor_season_history_screen.dart'
    as _i14;
import 'package:f1_pet_project/core/predictor/screens/predictor_weekend_detail_screen.dart'
    as _i15;
import 'package:f1_pet_project/core/profile/screens/auth_screens.dart' as _i1;
import 'package:f1_pet_project/core/profile/screens/profile_screen.dart'
    as _i16;
import 'package:f1_pet_project/core/results/constructor/screens/constructor_screen.dart'
    as _i4;
import 'package:f1_pet_project/core/results/driver/screens/driver_screen.dart'
    as _i5;
import 'package:f1_pet_project/core/results/finish_status/screens/finish_status_screen.dart'
    as _i6;
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart' as _i29;
import 'package:f1_pet_project/core/results/h2h/screens/h2h_constructors_screen.dart'
    as _i7;
import 'package:f1_pet_project/core/results/h2h/screens/h2h_screen.dart' as _i8;
import 'package:f1_pet_project/core/results/hall_of_fame/screens/hall_of_fame_screen.dart'
    as _i9;
import 'package:f1_pet_project/core/results/race_info/screens/race_info_screen.dart'
    as _i17;
import 'package:f1_pet_project/core/results/race_search/screens/race_search_screen.dart'
    as _i18;
import 'package:f1_pet_project/core/results/screens/results_screen.dart'
    as _i19;
import 'package:f1_pet_project/core/results/season_rewind/screens/season_rewind_screen.dart'
    as _i22;
import 'package:f1_pet_project/core/schedule/models/races_model.dart' as _i32;
import 'package:f1_pet_project/core/schedule/screens/schedule_screen.dart'
    as _i21;
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart'
    as _i26;
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart'
    as _i27;
import 'package:f1_pet_project/router/nested_router_screens.dart' as _i10;
import 'package:flutter/material.dart' as _i25;

/// generated route for
/// [_i1.AuthRegisterScreen]
class AuthRegisterRoute extends _i23.PageRouteInfo<void> {
  const AuthRegisterRoute({List<_i23.PageRouteInfo>? children})
    : super(AuthRegisterRoute.name, initialChildren: children);

  static const String name = 'AuthRegisterRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthRegisterScreen();
    },
  );
}

/// generated route for
/// [_i1.AuthSignInScreen]
class AuthSignInRoute extends _i23.PageRouteInfo<void> {
  const AuthSignInRoute({List<_i23.PageRouteInfo>? children})
    : super(AuthSignInRoute.name, initialChildren: children);

  static const String name = 'AuthSignInRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i1.AuthSignInScreen();
    },
  );
}

/// generated route for
/// [_i2.CircuitScreen]
class CircuitRoute extends _i23.PageRouteInfo<CircuitRouteArgs> {
  CircuitRoute({
    required _i24.CircuitModel circuitModel,
    _i25.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
         CircuitRoute.name,
         args: CircuitRouteArgs(circuitModel: circuitModel, key: key),
         initialChildren: children,
       );

  static const String name = 'CircuitRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CircuitRouteArgs>();
      return _i2.CircuitScreen(circuitModel: args.circuitModel, key: args.key);
    },
  );
}

class CircuitRouteArgs {
  const CircuitRouteArgs({required this.circuitModel, this.key});

  final _i24.CircuitModel circuitModel;

  final _i25.Key? key;

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
/// [_i3.CircuitsScreen]
class CircuitsRoute extends _i23.PageRouteInfo<void> {
  const CircuitsRoute({List<_i23.PageRouteInfo>? children})
    : super(CircuitsRoute.name, initialChildren: children);

  static const String name = 'CircuitsRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i3.CircuitsScreen();
    },
  );
}

/// generated route for
/// [_i4.ConstructorScreen]
class ConstructorRoute extends _i23.PageRouteInfo<ConstructorRouteArgs> {
  ConstructorRoute({
    required _i26.ConstructorModel constructor,
    List<_i27.DriverModel> currentDrivers = const [],
    _i25.Key? key,
    List<_i23.PageRouteInfo>? children,
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

  static _i23.PageInfo page = _i23.PageInfo(
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

  final _i26.ConstructorModel constructor;

  final List<_i27.DriverModel> currentDrivers;

  final _i25.Key? key;

  @override
  String toString() {
    return 'ConstructorRouteArgs{constructor: $constructor, currentDrivers: $currentDrivers, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ConstructorRouteArgs) return false;
    return constructor == other.constructor &&
        const _i28.ListEquality<_i27.DriverModel>().equals(
          currentDrivers,
          other.currentDrivers,
        ) &&
        key == other.key;
  }

  @override
  int get hashCode =>
      constructor.hashCode ^
      const _i28.ListEquality<_i27.DriverModel>().hash(currentDrivers) ^
      key.hashCode;
}

/// generated route for
/// [_i5.DriverScreen]
class DriverRoute extends _i23.PageRouteInfo<DriverRouteArgs> {
  DriverRoute({
    required _i27.DriverModel driver,
    List<_i26.ConstructorModel> currentConstructors = const [],
    _i25.Key? key,
    List<_i23.PageRouteInfo>? children,
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

  static _i23.PageInfo page = _i23.PageInfo(
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

  final _i27.DriverModel driver;

  final List<_i26.ConstructorModel> currentConstructors;

  final _i25.Key? key;

  @override
  String toString() {
    return 'DriverRouteArgs{driver: $driver, currentConstructors: $currentConstructors, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DriverRouteArgs) return false;
    return driver == other.driver &&
        const _i28.ListEquality<_i26.ConstructorModel>().equals(
          currentConstructors,
          other.currentConstructors,
        ) &&
        key == other.key;
  }

  @override
  int get hashCode =>
      driver.hashCode ^
      const _i28.ListEquality<_i26.ConstructorModel>().hash(
        currentConstructors,
      ) ^
      key.hashCode;
}

/// generated route for
/// [_i6.FinishStatusScreen]
class FinishStatusRoute extends _i23.PageRouteInfo<void> {
  const FinishStatusRoute({List<_i23.PageRouteInfo>? children})
    : super(FinishStatusRoute.name, initialChildren: children);

  static const String name = 'FinishStatusRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i6.FinishStatusScreen();
    },
  );
}

/// generated route for
/// [_i7.H2hConstructorsScreen]
class H2hConstructorsRoute extends _i23.PageRouteInfo<void> {
  const H2hConstructorsRoute({List<_i23.PageRouteInfo>? children})
    : super(H2hConstructorsRoute.name, initialChildren: children);

  static const String name = 'H2hConstructorsRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i7.H2hConstructorsScreen();
    },
  );
}

/// generated route for
/// [_i8.H2hScreen]
class H2hRoute extends _i23.PageRouteInfo<H2hRouteArgs> {
  H2hRoute({
    _i29.H2hMode initialMode = _i29.H2hMode.drivers,
    _i25.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
         H2hRoute.name,
         args: H2hRouteArgs(initialMode: initialMode, key: key),
         initialChildren: children,
       );

  static const String name = 'H2hRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<H2hRouteArgs>(
        orElse: () => const H2hRouteArgs(),
      );
      return _i8.H2hScreen(initialMode: args.initialMode, key: args.key);
    },
  );
}

class H2hRouteArgs {
  const H2hRouteArgs({this.initialMode = _i29.H2hMode.drivers, this.key});

  final _i29.H2hMode initialMode;

  final _i25.Key? key;

  @override
  String toString() {
    return 'H2hRouteArgs{initialMode: $initialMode, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! H2hRouteArgs) return false;
    return initialMode == other.initialMode && key == other.key;
  }

  @override
  int get hashCode => initialMode.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i9.HallOfFameScreen]
class HallOfFameRoute extends _i23.PageRouteInfo<void> {
  const HallOfFameRoute({List<_i23.PageRouteInfo>? children})
    : super(HallOfFameRoute.name, initialChildren: children);

  static const String name = 'HallOfFameRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i9.HallOfFameScreen();
    },
  );
}

/// generated route for
/// [_i10.HomeRouterScreen]
class HomeRouter extends _i23.PageRouteInfo<void> {
  const HomeRouter({List<_i23.PageRouteInfo>? children})
    : super(HomeRouter.name, initialChildren: children);

  static const String name = 'HomeRouter';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i10.HomeRouterScreen();
    },
  );
}

/// generated route for
/// [_i11.HomeScreen]
class HomeRoute extends _i23.PageRouteInfo<void> {
  const HomeRoute({List<_i23.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i11.HomeScreen();
    },
  );
}

/// generated route for
/// [_i12.PredictorLeaderboardScreen]
class PredictorLeaderboardRoute
    extends _i23.PageRouteInfo<PredictorLeaderboardRouteArgs> {
  PredictorLeaderboardRoute({
    required String year,
    int myPoints = 0,
    _i25.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
         PredictorLeaderboardRoute.name,
         args: PredictorLeaderboardRouteArgs(
           year: year,
           myPoints: myPoints,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'PredictorLeaderboardRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PredictorLeaderboardRouteArgs>();
      return _i12.PredictorLeaderboardScreen(
        year: args.year,
        myPoints: args.myPoints,
        key: args.key,
      );
    },
  );
}

class PredictorLeaderboardRouteArgs {
  const PredictorLeaderboardRouteArgs({
    required this.year,
    this.myPoints = 0,
    this.key,
  });

  final String year;

  final int myPoints;

  final _i25.Key? key;

  @override
  String toString() {
    return 'PredictorLeaderboardRouteArgs{year: $year, myPoints: $myPoints, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PredictorLeaderboardRouteArgs) return false;
    return year == other.year && myPoints == other.myPoints && key == other.key;
  }

  @override
  int get hashCode => year.hashCode ^ myPoints.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i10.PredictorRouterScreen]
class PredictorRouter extends _i23.PageRouteInfo<void> {
  const PredictorRouter({List<_i23.PageRouteInfo>? children})
    : super(PredictorRouter.name, initialChildren: children);

  static const String name = 'PredictorRouter';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i10.PredictorRouterScreen();
    },
  );
}

/// generated route for
/// [_i13.PredictorScreen]
class PredictorRoute extends _i23.PageRouteInfo<void> {
  const PredictorRoute({List<_i23.PageRouteInfo>? children})
    : super(PredictorRoute.name, initialChildren: children);

  static const String name = 'PredictorRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i13.PredictorScreen();
    },
  );
}

/// generated route for
/// [_i14.PredictorSeasonHistoryScreen]
class PredictorSeasonHistoryRoute
    extends _i23.PageRouteInfo<PredictorSeasonHistoryRouteArgs> {
  PredictorSeasonHistoryRoute({
    required _i30.PredictorSeason season,
    _i25.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
         PredictorSeasonHistoryRoute.name,
         args: PredictorSeasonHistoryRouteArgs(season: season, key: key),
         initialChildren: children,
       );

  static const String name = 'PredictorSeasonHistoryRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PredictorSeasonHistoryRouteArgs>();
      return _i14.PredictorSeasonHistoryScreen(
        season: args.season,
        key: args.key,
      );
    },
  );
}

class PredictorSeasonHistoryRouteArgs {
  const PredictorSeasonHistoryRouteArgs({required this.season, this.key});

  final _i30.PredictorSeason season;

  final _i25.Key? key;

  @override
  String toString() {
    return 'PredictorSeasonHistoryRouteArgs{season: $season, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PredictorSeasonHistoryRouteArgs) return false;
    return season == other.season && key == other.key;
  }

  @override
  int get hashCode => season.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i15.PredictorWeekendDetailScreen]
class PredictorWeekendDetailRoute
    extends _i23.PageRouteInfo<PredictorWeekendDetailRouteArgs> {
  PredictorWeekendDetailRoute({
    required String season,
    required _i31.PredictorWeekendPrediction weekend,
    _i25.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
         PredictorWeekendDetailRoute.name,
         args: PredictorWeekendDetailRouteArgs(
           season: season,
           weekend: weekend,
           key: key,
         ),
         initialChildren: children,
       );

  static const String name = 'PredictorWeekendDetailRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PredictorWeekendDetailRouteArgs>();
      return _i15.PredictorWeekendDetailScreen(
        season: args.season,
        weekend: args.weekend,
        key: args.key,
      );
    },
  );
}

class PredictorWeekendDetailRouteArgs {
  const PredictorWeekendDetailRouteArgs({
    required this.season,
    required this.weekend,
    this.key,
  });

  final String season;

  final _i31.PredictorWeekendPrediction weekend;

  final _i25.Key? key;

  @override
  String toString() {
    return 'PredictorWeekendDetailRouteArgs{season: $season, weekend: $weekend, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PredictorWeekendDetailRouteArgs) return false;
    return season == other.season &&
        weekend == other.weekend &&
        key == other.key;
  }

  @override
  int get hashCode => season.hashCode ^ weekend.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i10.ProfileRouterScreen]
class ProfileRouter extends _i23.PageRouteInfo<void> {
  const ProfileRouter({List<_i23.PageRouteInfo>? children})
    : super(ProfileRouter.name, initialChildren: children);

  static const String name = 'ProfileRouter';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i10.ProfileRouterScreen();
    },
  );
}

/// generated route for
/// [_i16.ProfileScreen]
class ProfileRoute extends _i23.PageRouteInfo<void> {
  const ProfileRoute({List<_i23.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i16.ProfileScreen();
    },
  );
}

/// generated route for
/// [_i17.RaceInfoScreen]
class RaceInfoRoute extends _i23.PageRouteInfo<RaceInfoRouteArgs> {
  RaceInfoRoute({
    required _i32.RacesModel raceModel,
    _i25.Key? key,
    List<_i23.PageRouteInfo>? children,
  }) : super(
         RaceInfoRoute.name,
         args: RaceInfoRouteArgs(raceModel: raceModel, key: key),
         initialChildren: children,
       );

  static const String name = 'RaceInfoRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RaceInfoRouteArgs>();
      return _i17.RaceInfoScreen(raceModel: args.raceModel, key: args.key);
    },
  );
}

class RaceInfoRouteArgs {
  const RaceInfoRouteArgs({required this.raceModel, this.key});

  final _i32.RacesModel raceModel;

  final _i25.Key? key;

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
/// [_i18.RaceSearchScreen]
class RaceSearchRoute extends _i23.PageRouteInfo<void> {
  const RaceSearchRoute({List<_i23.PageRouteInfo>? children})
    : super(RaceSearchRoute.name, initialChildren: children);

  static const String name = 'RaceSearchRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i18.RaceSearchScreen();
    },
  );
}

/// generated route for
/// [_i10.ResultsRouterScreen]
class ResultsRouter extends _i23.PageRouteInfo<void> {
  const ResultsRouter({List<_i23.PageRouteInfo>? children})
    : super(ResultsRouter.name, initialChildren: children);

  static const String name = 'ResultsRouter';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i10.ResultsRouterScreen();
    },
  );
}

/// generated route for
/// [_i19.ResultsScreen]
class ResultsRoute extends _i23.PageRouteInfo<void> {
  const ResultsRoute({List<_i23.PageRouteInfo>? children})
    : super(ResultsRoute.name, initialChildren: children);

  static const String name = 'ResultsRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i19.ResultsScreen();
    },
  );
}

/// generated route for
/// [_i20.ScaffoldWithNavBarScreen]
class ScaffoldWithNavBarRoute extends _i23.PageRouteInfo<void> {
  const ScaffoldWithNavBarRoute({List<_i23.PageRouteInfo>? children})
    : super(ScaffoldWithNavBarRoute.name, initialChildren: children);

  static const String name = 'ScaffoldWithNavBarRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i20.ScaffoldWithNavBarScreen();
    },
  );
}

/// generated route for
/// [_i10.ScheduleRouterScreen]
class ScheduleRouter extends _i23.PageRouteInfo<void> {
  const ScheduleRouter({List<_i23.PageRouteInfo>? children})
    : super(ScheduleRouter.name, initialChildren: children);

  static const String name = 'ScheduleRouter';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i10.ScheduleRouterScreen();
    },
  );
}

/// generated route for
/// [_i21.ScheduleScreen]
class ScheduleRoute extends _i23.PageRouteInfo<void> {
  const ScheduleRoute({List<_i23.PageRouteInfo>? children})
    : super(ScheduleRoute.name, initialChildren: children);

  static const String name = 'ScheduleRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i21.ScheduleScreen();
    },
  );
}

/// generated route for
/// [_i22.SeasonRewindScreen]
class SeasonRewindRoute extends _i23.PageRouteInfo<void> {
  const SeasonRewindRoute({List<_i23.PageRouteInfo>? children})
    : super(SeasonRewindRoute.name, initialChildren: children);

  static const String name = 'SeasonRewindRoute';

  static _i23.PageInfo page = _i23.PageInfo(
    name,
    builder: (data) {
      return const _i22.SeasonRewindScreen();
    },
  );
}
