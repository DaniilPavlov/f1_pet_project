import 'package:auto_route/auto_route.dart';
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

abstract class IRaceInfoScreenWM extends IWidgetModel {
  /// показываем ли аппбар таблицы гонки
  ListenableState<bool> get raceAppBarPinned;

  /// показываем ли аппбар таблицы квалификации
  ListenableState<bool> get qualificationAppBarPinned;

  /// показываем ли аппбар таблицы пит стопов
  ListenableState<bool> get pitStopsAppBarPinned;

  // основная информация гонки
  RacesModel get raceModel;

  // информация о квалификации
  ListenableState<EntityState<List<QualifyingResultsModel>>>
      get qualifyingResults;

  // информация о пит стопах
  ListenableState<EntityState<List<PitStopsModel>>> get pitStops;

  /// загружены ли начальные данные
  ListenableState<bool> get allDataIsLoaded;

  /// время лучшего круга
  String get fastestLap;

  /// загрузка всех данных
  void loadAllData();

  /// загрузка результатов квалификации
  void loadQualifyingResults();

  /// загрузка результатов пит стопов
  void loadPitStops();

  /// проверка видимости таблицы гонки
  void onRaceTableVisibilityChanged(VisibilityInfo info);

  /// проверка видимости таблицы квалификации
  void onQualificationTableVisibilityChanged(VisibilityInfo info);

  /// проверка видимости таблицы пит стопов
  void onPitStopsTableVisibilityChanged(VisibilityInfo info);

  /// закрытие страницы
  void onPop();
}

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

  @override
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

  @override
  Future<void> loadAllData() async {
    _allDataIsLoaded.accept(false);
    await Future.wait(
      [
        loadQualifyingResults(),
        loadPitStops(),
      ],
    );

    for (final element in raceModel.Results!) {
      if (element.FastestLap != null && _fastestLap.compareTo(element.FastestLap!.Time.time) == 1) {
        _fastestLap = element.FastestLap!.Time.time;
      }
    }
    _allDataIsLoaded.accept(true);
  }

  @override
  void onPop() => context.router.removeLast();

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
}

RaceInfoScreenWM createRaceInfoScreenWM({
  required BuildContext context,
  required RacesModel racesModel,
}) {
  return RaceInfoScreenWM(model: RaceInfoScreenModel(), racesModel: racesModel);
}
