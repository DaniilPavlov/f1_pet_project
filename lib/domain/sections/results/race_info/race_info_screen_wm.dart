import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/sections/results/driver/driver_fetching_model.dart';
import 'package:f1_pet_project/data/models/sections/results/pit_stops_model.dart';
import 'package:f1_pet_project/data/models/sections/results/qualifying_results_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/race_info_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_screen.dart';
import 'package:flutter/foundation.dart';

import 'package:visibility_detector/visibility_detector.dart';

class RaceInfoScreenWM extends WidgetModel<RaceInfoScreen, RaceInfoScreenModel> implements IRaceInfoScreenWM {
  RaceInfoScreenWM({
    required RaceInfoScreenModel model,
    required RacesModel racesModel,
  }) : super(model) {
    _raceModel = racesModel;
  }
  final _raceAppBarPinned = StateNotifier<bool>(initValue: true);

  final _qualificationAppBarPinned = StateNotifier<bool>(initValue: false);

  final _pitStopsAppBarPinned = StateNotifier<bool>(initValue: false);

  final _screenError = StateNotifier<CustomException?>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  late final RacesModel _raceModel;

  final _qualifyingResults = EntityStateNotifier<List<QualifyingResultsModel>>();

  final _pitStops = EntityStateNotifier<List<PitStopsModel>>();

  @override
  ListenableState<CustomException?> get screenError => _screenError;

  @override
  ValueListenable<EntityState<List<QualifyingResultsModel>>> get qualifyingResults => _qualifyingResults;

  @override
  ValueListenable<EntityState<List<PitStopsModel>>> get pitStops => _pitStops;

  @override
  ListenableState<bool> get raceAppBarPinned => _raceAppBarPinned;

  @override
  ListenableState<bool> get qualificationAppBarPinned => _qualificationAppBarPinned;

  @override
  ListenableState<bool> get pitStopsAppBarPinned => _pitStopsAppBarPinned;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  @override
  RacesModel get raceModel => _raceModel;

  @override
  String get fastestLap => _fastestLap;

  String _fastestLap = '999999';

  @override
  void initWidgetModel() {
    loadAllData();
    super.initWidgetModel();
  }

  @override
  Future<void> loadAllData() async {
    _screenError.accept(null);
    _allDataIsLoaded.accept(false);
    await Future.wait(
      [
        loadQualifyingResults(),
        loadPitStops(),
      ],
    );

    if (_screenError.value == null) {
      for (final element in raceModel.results!) {
        if (element.fastestLap != null && _fastestLap.compareTo(element.fastestLap!.time.time) == 1) {
          _fastestLap = element.fastestLap!.time.time;
        }
      }
    }

    _allDataIsLoaded.accept(true);
  }

  @override
  void onPop() => context.router.removeLast();

  @override
  void onRaceTableVisibilityChanged(VisibilityInfo info) {
    _raceAppBarPinned.accept(
      info.visibleBounds.top < info.size.height - 150 && info.visibleBounds.right != 0,
    );
  }

  @override
  void onQualificationTableVisibilityChanged(VisibilityInfo info) {
    _qualificationAppBarPinned.accept(
      info.visibleBounds.top < info.size.height - 150 && info.visibleBounds.right != 0,
    );
  }

  @override
  void onPitStopsTableVisibilityChanged(VisibilityInfo info) {
    _pitStopsAppBarPinned.accept(
      info.visibleBounds.top < info.size.height - 150 && info.visibleBounds.right != 0,
    );
  }

  Future<void> loadQualifyingResults() async {
    await execute<ScheduleModel>(
      () => model.loadQualifyingResults(
        year: _raceModel.season,
        round: _raceModel.round,
      ),
      before: _qualifyingResults.loading,
      onSuccess: (data) {
        if (data!.raceTable.races.isEmpty) {
          _qualifyingResults.content([]);
        } else {
          _qualifyingResults.content(data.raceTable.races[0].qualifyingResults!);
        }
      },
      onError: (value) {
        _screenError.accept(value);
        _qualifyingResults.error(value);
      },
    );
  }

  Future<void> loadPitStops() async {
    var stops = <PitStopsModel>[];
    await execute<ScheduleModel>(
      () => model.loadPitStops(
        year: _raceModel.season,
        round: _raceModel.round,
      ),
      before: _pitStops.loading,
      onSuccess: (data) {
        if (data!.raceTable.races.isEmpty) {
          stops = [];
        } else {
          stops = data.raceTable.races[0].pitStops!;
        }
      },
      onError: (value) {
        _screenError.accept(value);
        _pitStops.error(value);
      },
    );
    if (!_pitStops.value.isErrorState) {
      for (var i = 0; i < stops.length; i++) {
        await execute<DriverFetchingModel>(
          () => model.loadDriverInfo(driverId: stops[i].driverId),
          onSuccess: (data) {
            stops[i] = stops[i].copyWith(
              driverId: '${data!.driverTable.drivers[0].givenName} ${data.driverTable.drivers[0].familyName}',
            );
          },
          onError: (value) {
            _screenError.accept(value);
            _pitStops.error(value);
          },
        );
        _pitStops.content(stops);
      }
    }
  }
}

RaceInfoScreenWM createRaceInfoScreenWM({required RacesModel racesModel}) =>
    RaceInfoScreenWM(model: RaceInfoScreenModel(), racesModel: racesModel);

abstract interface class IRaceInfoScreenWM implements IWidgetModel {
  /// Returns is race app bar pinned.
  ListenableState<bool> get raceAppBarPinned;

  /// Returns is qualification app bar pinned.
  ListenableState<bool> get qualificationAppBarPinned;

  /// Returns is pit stops app bar pinned.
  ListenableState<bool> get pitStopsAppBarPinned;

  /// Returns race main info.
  RacesModel get raceModel;

  /// Returns qualification results.
  ValueListenable<EntityState<List<QualifyingResultsModel>>> get qualifyingResults;

  /// Returns pit stops info.
  ValueListenable<EntityState<List<PitStopsModel>>> get pitStops;

  /// Returns error.
  ListenableState<CustomException?> get screenError;

  /// Returns is all data loaded.
  ListenableState<bool> get allDataIsLoaded;

  /// Returns fastest lap.
  String get fastestLap;

  /// Loads all data.
  void loadAllData();

  /// Invokes when race table visibility changed.
  void onRaceTableVisibilityChanged(VisibilityInfo info);

  /// Invokes when qualification table visibility changed.
  void onQualificationTableVisibilityChanged(VisibilityInfo info);

  /// Invokes when pit stops table visibility changed.
  void onPitStopsTableVisibilityChanged(VisibilityInfo info);

  /// Closes screen.
  void onPop();
}
