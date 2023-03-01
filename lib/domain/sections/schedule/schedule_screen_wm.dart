import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/schedule_model.dart';
import 'package:f1_pet_project/domain/sections/schedule/schedule_screen_model.dart';
import 'package:f1_pet_project/domain/services/executor.dart';
import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart';
import 'package:flutter/material.dart';

abstract class IScheduleScreenWM extends IWidgetModel {
  /// расписание
  ListenableState<EntityState<List<RacesModel>>> get racesElements;

  /// загружены ли начальные данные
  ListenableState<bool> get allDataIsLoaded;

  /// загрузка расписания сезона
  void loadSchedule();

  /// загрузка всех данных
  void loadAllData();
}

class ScheduleScreenWM extends WidgetModel<ScheduleScreen, ScheduleScreenModel>
    implements IScheduleScreenWM {
  final _racesElements = EntityStateNotifier<List<RacesModel>>();

  final _allDataIsLoaded = StateNotifier<bool>(initValue: false);

  @override
  ListenableState<EntityState<List<RacesModel>>> get racesElements =>
      _racesElements;

  @override
  ListenableState<bool> get allDataIsLoaded => _allDataIsLoaded;

  ScheduleScreenWM(super.model);

  @override
  void initWidgetModel() {
    loadAllData();

    super.initWidgetModel();
  }

  @override
  Future<void> loadSchedule() async {
    await execute<ScheduleModel>(
      model.loadSchedule,
      before: _racesElements.loading,
      onSuccess: (data) {
        _racesElements.content(data!.RaceTable.Races);
      },
      onError: _racesElements.error,
    );
  }

  @override
  Future<void> loadAllData() async {
    _allDataIsLoaded.accept(false);

    await Future.wait(
      [
        loadSchedule(),
      ],
    );

    _allDataIsLoaded.accept(true);
  }
}

ScheduleScreenWM createScheduleScreenWM(BuildContext _) =>
    ScheduleScreenWM(ScheduleScreenModel());
