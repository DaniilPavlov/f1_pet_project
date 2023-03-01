import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_model.dart';
import 'package:f1_pet_project/domain/sections/hall_of_fame/hall_of_fame_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart';
import 'package:flutter/material.dart';

abstract class IHallOfFameScreenWM extends IWidgetModel {
  /// пилоты чемпионы
  ListenableState<EntityState<List<StandingsListsModel>>> get driversChampions;

  /// конструкторы чемпионы
  ListenableState<EntityState<List<StandingsListsModel>>>
      get constructorsChampions;

  /// загружены ли начальные данные
  ListenableState<bool> get allDataIsLoaded;

  /// загрузка пилотов чемпионов
  void loadDriversChampions();

  /// загрузка конструкторов чемпионов
  void loadConstructorsChampions();

  /// загрузка всех данных
  void loadAllData();
}

class HallOfFameScreenWM
    extends WidgetModel<HallOfFameScreen, HallOfFameScreenModel>
    implements IHallOfFameScreenWM {
  final _driversChampions = EntityStateNotifier<List<StandingsListsModel>>();

  final _constructorsChampions =
      EntityStateNotifier<List<StandingsListsModel>>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);
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
  Future<void> loadDriversChampions() async {
    await execute<StandingsModel>(
      model.loadDriversChampions,
      before: _driversChampions.loading,
      onSuccess: (data) {
        _driversChampions.content(data!.StandingsTable.StandingsLists);
      },
      onError: _driversChampions.error,
    );
  }

  @override
  Future<void> loadConstructorsChampions() async {
    await execute<StandingsModel>(
      model.loadConstructorsChampions,
      before: _constructorsChampions.loading,
      onSuccess: (data) {
        _constructorsChampions.content(
          data!.StandingsTable.StandingsLists,
        );
      },
      onError: _constructorsChampions.error,
    );
  }

  @override
  Future<void> loadAllData() async {
    _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        loadConstructorsChampions(),
        loadDriversChampions(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }
}

HallOfFameScreenWM createHallOfFameScreenWM(BuildContext _) =>
    HallOfFameScreenWM(HallOfFameScreenModel());
