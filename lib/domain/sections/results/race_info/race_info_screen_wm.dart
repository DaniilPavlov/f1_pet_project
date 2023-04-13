import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/results/driver/driver_fetching_model.dart';
import 'package:f1_pet_project/data/models/sections/results/pit_stops_model.dart';
import 'package:f1_pet_project/data/models/sections/results/qualifying_results_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_info/race_info_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_screen.dart';
import 'package:flutter/material.dart';

import 'package:visibility_detector/visibility_detector.dart';

class RaceInfoScreenWM extends WidgetModel<RaceInfoScreen, RaceInfoScreenModel>
    implements IRaceInfoScreenWM {
  final _raceAppBarPinned = StateNotifier<bool>(initValue: true);

  final _qualificationAppBarPinned = StateNotifier<bool>(initValue: false);

  final _pitStopsAppBarPinned = StateNotifier<bool>(initValue: false);

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  late final RacesModel _raceModel;

  final _qualifyingResults =
      EntityStateNotifier<List<QualifyingResultsModel>>();

  final _pitStops = EntityStateNotifier<List<PitStopsModel>>();

  @override
  ListenableState<EntityState<List<QualifyingResultsModel>>>
      get qualifyingResults => _qualifyingResults;

  @override
  ListenableState<EntityState<List<PitStopsModel>>> get pitStops => _pitStops;

  @override
  ListenableState<bool> get raceAppBarPinned => _raceAppBarPinned;

  @override
  ListenableState<bool> get qualificationAppBarPinned =>
      _qualificationAppBarPinned;

  @override
  ListenableState<bool> get pitStopsAppBarPinned => _pitStopsAppBarPinned;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  @override
  RacesModel get raceModel => _raceModel;

  @override
  String get fastestLap => _fastestLap;

  String _fastestLap = '999999';

  RaceInfoScreenWM({
    required RaceInfoScreenModel model,
    required RacesModel racesModel,
  }) : super(model) {
    _raceModel = racesModel;
  }

  @override
  void initWidgetModel() {
    loadAllData();
    super.initWidgetModel();
  }

  @override
  void onPop() => Navigator.of(context).pop();

  @override
  void onRaceTableVisibilityChanged(VisibilityInfo info) {
    _raceAppBarPinned.accept(info.visibleBounds.top < info.size.height - 150 &&
        info.visibleBounds.right != 0);
  }

  @override
  void onQualificationTableVisibilityChanged(VisibilityInfo info) {
    _qualificationAppBarPinned.accept(
      info.visibleBounds.top < info.size.height - 150 &&
          info.visibleBounds.right != 0,
    );
  }

  @override
  void onPitStopsTableVisibilityChanged(VisibilityInfo info) {
    _pitStopsAppBarPinned.accept(
      info.visibleBounds.top < info.size.height - 150 &&
          info.visibleBounds.right != 0,
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
        _qualifyingResults.content(data!.RaceTable.Races[0].QualifyingResults!);
      },
      onError: _qualifyingResults.error,
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
        stops = data!.RaceTable.Races[0].PitStops!;
      },
      onError: _pitStops.error,
    );
    if (_pitStops.value?.error == null) {
      for (var i = 0; i < stops.length; i++) {
        await execute<DriverFetchingModel>(
          () => model.loadDriverInfo(driverId: stops[i].driverId),
          onSuccess: (data) {
            stops[i] = stops[i].copyWith(
              driverId:
                  '${data!.DriverTable.Drivers[0].givenName} ${data.DriverTable.Drivers[0].familyName}',
            );
          },
          onError: _pitStops.error,
        );
        _pitStops.content(stops);
      }
    }
  }

  Future<void> loadAllData() async {
    _allDataIsLoaded.accept(false);
    await Future.wait(
      [
        loadQualifyingResults(),
        loadPitStops(),
      ],
    );

    for (final element in raceModel.Results!) {
      if (element.FastestLap != null &&
          _fastestLap.compareTo(element.FastestLap!.Time.time) == 1) {
        _fastestLap = element.FastestLap!.Time.time;
      }
    }
    _allDataIsLoaded.accept(true);
  }
}

RaceInfoScreenWM createRaceInfoScreenWM({required RacesModel racesModel}) =>
    RaceInfoScreenWM(model: RaceInfoScreenModel(), racesModel: racesModel);

abstract class IRaceInfoScreenWM extends IWidgetModel {
  /// Returns is race app bar pinned.
  ListenableState<bool> get raceAppBarPinned;

  /// Returns is qualification app bar pinned.
  ListenableState<bool> get qualificationAppBarPinned;

  /// Returns is pit stops app bar pinned.
  ListenableState<bool> get pitStopsAppBarPinned;

  /// Returns race main info.
  RacesModel get raceModel;

  /// Returns qualification results.
  ListenableState<EntityState<List<QualifyingResultsModel>>>
      get qualifyingResults;

  /// Returns pit stops info.
  ListenableState<EntityState<List<PitStopsModel>>> get pitStops;

  /// Returns is all data loaded.
  ListenableState<bool> get allDataIsLoaded;

  /// Returns fastest lap.
  String get fastestLap;

  /// Invokes when race table visibility changed.
  void onRaceTableVisibilityChanged(VisibilityInfo info);

  /// Invokes when qualification table visibility changed.
  void onQualificationTableVisibilityChanged(VisibilityInfo info);

  /// Invokes when pit stops table visibility changed.
  void onPitStopsTableVisibilityChanged(VisibilityInfo info);

  /// Closes screen.
  void onPop();
}
