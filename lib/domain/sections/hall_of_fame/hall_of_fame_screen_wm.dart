import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/hall_of_fame_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HallOfFameScreenWM extends WidgetModel<HallOfFameScreen, HallOfFameScreenModel> implements IHallOfFameScreenWM {
  HallOfFameScreenWM(super._model);
  final _driversStandings = EntityStateNotifier<List<StandingsListsModel>>();

  final _constructorsStandings = EntityStateNotifier<List<StandingsListsModel>>();

  final _screenError = StateNotifier<CustomException?>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  final _yearController = TextEditingController(text: '2025');

  final _fieldsInputted = StateNotifier<bool>(initValue: true);

  @override
  ListenableState<CustomException?> get screenError => _screenError;

  @override
  ValueListenable<EntityState<List<StandingsListsModel>>> get driversStandings => _driversStandings;
  @override
  ValueListenable<EntityState<List<StandingsListsModel>>> get constructorsStandings => _constructorsStandings;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  @override
  TextEditingController get yearController => _yearController;

  @override
  ListenableState<bool> get fieldsInputted => _fieldsInputted;

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
        loadConstructorsStandings(year: _yearController.text),
        loadDriversStandings(year: _yearController.text),
      ],
    );

    _allDataIsLoaded.accept(true);
  }

  Future<void> loadDriversStandings({required String year}) async {
    await execute<StandingsModel>(
      () => model.loadDriversStandings(year: year),
      before: _driversStandings.loading,
      onSuccess: (data) {
        _driversStandings.content(data!.standingsTable.standingsLists);
      },
      onError: (value) {
        _screenError.accept(value);
        _driversStandings.error(value);
      },
    );
  }

  Future<void> loadConstructorsStandings({required String year}) async {
    await execute<StandingsModel>(
      () => model.loadConstructorsStandings(year: year),
      before: _constructorsStandings.loading,
      onSuccess: (data) {
        _constructorsStandings.content(
          data!.standingsTable.standingsLists,
        );
      },
      onError: (value) {
        _screenError.accept(value);
        _constructorsStandings.error(value);
      },
    );
  }

  @override
  void checkFields() => _fieldsInputted.accept(_yearController.text.length == 4);
}

HallOfFameScreenWM createHallOfFameScreenWM(BuildContext _) => HallOfFameScreenWM(HallOfFameScreenModel());

abstract interface class IHallOfFameScreenWM implements IWidgetModel {
  /// Returns drivers standings.
  ValueListenable<EntityState<List<StandingsListsModel>>> get driversStandings;

  /// Returns constructors standings.
  ValueListenable<EntityState<List<StandingsListsModel>>> get constructorsStandings;

  /// Returns error.
  ListenableState<CustomException?> get screenError;

  /// Returns is all data loaded.
  ListenableState<bool> get allDataIsLoaded;

  /// Returns are fields inputted.
  ListenableState<bool> get fieldsInputted;

  /// Returns year text field controller.
  TextEditingController get yearController;

  /// Checks are fields valid.
  void checkFields();

  /// Loads all data.
  void loadAllData();
}
