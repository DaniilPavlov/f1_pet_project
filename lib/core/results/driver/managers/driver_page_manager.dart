import 'dart:async';

import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/models/espn/espn_driver_card_data.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_media_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_career_repository.dart';
import 'package:f1_pet_project/core/results/driver/state/state_holders/driver_page_state_holder.dart';
import 'package:f1_pet_project/core/results/driver/state/state_models/driver_page_args.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';

/// Загружает карьеру (Jolpica) и ESPN-медиа пилота.
class DriverPageManager {
  DriverPageManager({
    required this.args,
    required DriverPageStateHolder holder,
    DriverCareerRepository? careerRepository,
    EspnMediaRepository? espnMediaRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting
    Future<CareerStats<ConstructorModel>> Function({
      required String driverId,
      List<ConstructorModel> current,
    })?
    fetchCareerStatsForTest,
  }) : _holder = holder,
       _careerRepository = careerRepository,
       _espnMediaRepository = espnMediaRepository,
       _dataRefresh = dataRefresh,
       _fetchCareerStatsForTest = fetchCareerStatsForTest;

  /// Аргументы экрана: пилот и его команды.
  final DriverPageArgs args;
  final DriverPageStateHolder _holder;
  final DriverCareerRepository? _careerRepository;
  final EspnMediaRepository? _espnMediaRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<CareerStats<ConstructorModel>> Function({
    required String driverId,
    List<ConstructorModel> current,
  })?
  _fetchCareerStatsForTest;

  var _disposed = false;

  /// Пилот для отображения.
  DriverModel get driver => args.driver;

  /// Текущие команды пилота.
  List<ConstructorModel> get currentConstructors => args.currentConstructors;

  /// Очищает ресурсы менеджера.
  void dispose() => _disposed = true;

  /// Загружает карьеру и ESPN-данные параллельно.
  Future<void> loadAll() async {
    await Future.wait([loadCareerStats(), loadEspnCard()]);
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (_disposed) {
      return;
    }
    await loadAll();
  }

  /// Totals сразу, списки гонок — фоном (progressive).
  Future<void> loadCareerStats() async {
    final forTest = _fetchCareerStatsForTest;
    if (forTest != null) {
      await runAsyncLoad(
        fetch: () => forTest(driverId: driver.driverId, current: currentConstructors),
        getField: () => _holder.viewModel.careerStats,
        setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(careerStats: value)),
        onSuccess: (data) {
          if (data != null) {
            _holder.setViewModel(
              _holder.viewModel.copyWith(careerStats: _holder.viewModel.careerStats.toValue(data)),
            );
          }
        },
      );
      return;
    }

    await runAsyncLoad(
      fetch: () => _careerRepository!.loadTotals(
        driverId: driver.driverId,
        current: currentConstructors,
      ),
      getField: () => _holder.viewModel.careerStats,
      setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(careerStats: value)),
      onSuccess: (data) {
        if (data != null) {
          _holder.setViewModel(
            _holder.viewModel.copyWith(careerStats: _holder.viewModel.careerStats.toValue(data)),
          );
          unawaited(_completeRaceLists(data));
        }
      },
    );
  }

  Future<void> _completeRaceLists(CareerStats<ConstructorModel> totals) async {
    try {
      final complete = await _careerRepository!.loadRaceLists(
        driverId: driver.driverId,
        totals: totals,
      );
      if (_disposed) {
        return;
      }
      final current = _holder.viewModel.careerStats.value;
      if (current == null || current.races != totals.races || current.wins != totals.wins) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(careerStats: _holder.viewModel.careerStats.toValue(complete)),
      );
    } on Object {
      // Totals уже на экране — списки просто останутся неполными.
    }
  }

  /// Загружает фото / флаг / новости ESPN (ошибка → пустые данные, экран не ломаем).
  Future<void> loadEspnCard() async {
    if (_fetchCareerStatsForTest != null) {
      _holder.setViewModel(
        _holder.viewModel.copyWith(espnCard: const Loadable.value(value: EspnDriverCardData())),
      );
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(espnCard: _holder.viewModel.espnCard.toLoading()));
    try {
      final data = await _espnMediaRepository!.driverCardData(
        givenName: driver.givenName,
        familyName: driver.familyName,
      );
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(espnCard: _holder.viewModel.espnCard.toValue(data)),
      );
    } on Object {
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(espnCard: _holder.viewModel.espnCard.toValue(const EspnDriverCardData())),
      );
    }
  }
}
