import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/results_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart';
import 'package:flutter/material.dart';

abstract class IResultsScreenWM extends IWidgetModel {
  /// результаты последней гонки
  ListenableState<EntityState<RacesModel>> get lastRace;

  /// загружены ли начальные данные
  ListenableState<bool> get allDataIsLoaded;

  /// загрузка результатов последней гонки
  void loadLastRaceResults();

  /// загрузка всех данных
  void loadAllData();
}

class ResultsScreenWM extends WidgetModel<ResultsScreen, ResultsScreenModel>
    implements IResultsScreenWM {
  final _lastRace = EntityStateNotifier<RacesModel>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  @override
  ListenableState<EntityState<RacesModel>> get lastRace => _lastRace;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  ResultsScreenWM(super.model);

  @override
  void initWidgetModel() {
    loadAllData();

    super.initWidgetModel();
  }

  @override
  Future<void> loadLastRaceResults() async {
    await execute<ScheduleModel>(
      model.loadLastRaceResults,
      before: _lastRace.loading,
      onSuccess: (data) {
        _lastRace.content(data!.RaceTable.Races[0]);
      },
      onError: _lastRace.error,
    );
  }

  @override
  Future<void> loadAllData() async {
    _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        loadLastRaceResults(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }
}

ResultsScreenWM createResultsScreenWM(BuildContext _) =>
    ResultsScreenWM(ResultsScreenModel());
