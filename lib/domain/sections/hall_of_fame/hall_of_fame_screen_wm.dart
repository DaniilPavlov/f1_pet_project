import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/hall_of_fame_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart';
import 'package:flutter/material.dart';

class HallOfFameScreenWM
    extends WidgetModel<HallOfFameScreen, HallOfFameScreenModel>
    implements IHallOfFameScreenWM {
  final _driversChampions = EntityStateNotifier<List<StandingsListsModel>>();

  final _constructorsChampions =
      EntityStateNotifier<List<StandingsListsModel>>();

  final _screenError = StateNotifier<CustomException?>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  @override
  ListenableState<CustomException?> get screenError => _screenError;

  @override
  ListenableState<EntityState<List<StandingsListsModel>>>
      get driversChampions => _driversChampions;
  @override
  ListenableState<EntityState<List<StandingsListsModel>>>
      get constructorsChampions => _constructorsChampions;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  HallOfFameScreenWM(super.model);

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
        loadConstructorsChampions(),
        loadDriversChampions(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }

  Future<void> loadDriversChampions() async {
    await execute<StandingsModel>(
      model.loadDriversChampions,
      before: _driversChampions.loading,
      onSuccess: (data) {
        _driversChampions.content(data!.StandingsTable.StandingsLists);
      },
      onError: (value) {
        _screenError.accept(value);
        _driversChampions.error(value);
      },
    );
  }

  Future<void> loadConstructorsChampions() async {
    await execute<StandingsModel>(
      model.loadConstructorsChampions,
      before: _constructorsChampions.loading,
      onSuccess: (data) {
        _constructorsChampions.content(
          data!.StandingsTable.StandingsLists,
        );
      },
      onError: (value) {
        _screenError.accept(value);
        _constructorsChampions.error(value);
      },
    );
  }
}

HallOfFameScreenWM createHallOfFameScreenWM(BuildContext _) =>
    HallOfFameScreenWM(HallOfFameScreenModel());

abstract class IHallOfFameScreenWM extends IWidgetModel {
  /// Returns drivers champions.
  ListenableState<EntityState<List<StandingsListsModel>>> get driversChampions;

  /// Returns constructors champions.
  ListenableState<EntityState<List<StandingsListsModel>>>
      get constructorsChampions;

  /// Returns error.
  ListenableState<CustomException?> get screenError;

  /// Returns is all data loaded.
  ListenableState<bool> get allDataIsLoaded;

  /// Loads all data.
  void loadAllData();
}
