import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/results/race_search/race_search_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/race_search_screen.dart';
import 'package:flutter/material.dart';

abstract class IRaceSearchScreenWM extends IWidgetModel {
  /// год
  TextEditingController get yearController;

  /// раунд
  TextEditingController get roundController;

  /// результаты гонки
  ListenableState<EntityState<RacesModel>> get searchedRace;

  /// загружены ли данные
  ListenableState<bool> get dataIsLoaded;

  /// загружены ли данные
  ListenableState<bool> get fieldsInputted;

  /// закрытие страницы
  void onPop();

  /// загрузка результатов для конкретной гонки
  void loadRaceResults();

  /// загрузка результатов для конкретной гонки
  void checkFields();
}

class RaceSearchScreenWM
    extends WidgetModel<RaceSearchScreen, RaceSearchScreenModel>
    implements IRaceSearchScreenWM {
  final _yearController = TextEditingController();

  final _roundController = TextEditingController();

  final _searchedRace = EntityStateNotifier<RacesModel>();

  final _dataIsLoaded = StateNotifier<bool>(initValue: true);

  final _fieldsInputted = StateNotifier<bool>(initValue: false);

  @override
  ListenableState<EntityState<RacesModel>> get searchedRace => _searchedRace;

  @override
  ListenableState<bool> get dataIsLoaded => _dataIsLoaded;

  @override
  ListenableState<bool> get fieldsInputted => _fieldsInputted;

  @override
  TextEditingController get yearController => _yearController;

  @override
  TextEditingController get roundController => _roundController;

  RaceSearchScreenWM(super.model);

  @override
  void onPop() {
    context.router.removeLast();
  }

  @override
  void checkFields() => _fieldsInputted.accept(
        _yearController.text.isNotEmpty && _roundController.text.isNotEmpty,
      );

  @override
  Future<void> loadRaceResults() async {
    _dataIsLoaded.accept(false);
    FocusManager.instance.primaryFocus?.unfocus();
    await execute<ScheduleModel>(
      () => model.loadRaceResults(
        year: _yearController.text,
        round: _roundController.text,
      ),
      before: _searchedRace.loading,
      onSuccess: (data) {
        _searchedRace.content(data!.RaceTable.Races[0]);
      },
      onError: _searchedRace.error,
    );
    _dataIsLoaded.accept(true);
  }
}

RaceSearchScreenWM createCertainRaceScreenWM(BuildContext _) =>
    RaceSearchScreenWM(RaceSearchScreenModel());
