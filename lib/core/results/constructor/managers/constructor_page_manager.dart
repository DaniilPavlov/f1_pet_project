import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_media_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_career_repository.dart';
import 'package:f1_pet_project/core/results/constructor/state/state_holders/constructor_page_state_holder.dart';
import 'package:f1_pet_project/core/results/constructor/state/state_models/constructor_page_args.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';

/// Загружает карьеру (Jolpica) и новости команды (ESPN).
class ConstructorPageManager {
  ConstructorPageManager({
    required this.args,
    required ConstructorPageStateHolder holder,
    ConstructorCareerRepository? careerRepository,
    EspnMediaRepository? espnMediaRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting
    Future<CareerStats<DriverModel>> Function({
      required String constructorId,
      List<DriverModel> current,
    })?
    fetchCareerStatsForTest,
  }) : _holder = holder,
       _careerRepository = careerRepository,
       _espnMediaRepository = espnMediaRepository,
       _dataRefresh = dataRefresh,
       _fetchCareerStatsForTest = fetchCareerStatsForTest;

  /// Аргументы экрана: команда и её пилоты.
  final ConstructorPageArgs args;
  final ConstructorPageStateHolder _holder;
  final ConstructorCareerRepository? _careerRepository;
  final EspnMediaRepository? _espnMediaRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<CareerStats<DriverModel>> Function({
    required String constructorId,
    List<DriverModel> current,
  })?
  _fetchCareerStatsForTest;

  var _disposed = false;

  /// Команда для отображения.
  ConstructorModel get constructor => args.constructor;

  /// Текущие пилоты команды.
  List<DriverModel> get currentDrivers => args.currentDrivers;

  /// Очищает ресурсы менеджера.
  void dispose() => _disposed = true;

  /// Загружает карьеру и ESPN-новости параллельно.
  Future<void> loadAll() async {
    await Future.wait([loadCareerStats(), loadEspnNews()]);
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (_disposed) {
      return;
    }
    await loadAll();
  }

  /// Загружает (или перезагружает) карьерную статистику.
  Future<void> loadCareerStats() async {
    await runAsyncLoad(
      fetch: () => _fetchCareerStats(constructorId: constructor.constructorId, current: currentDrivers),
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
  }

  /// ESPN-новости команды (ошибка → пустой список, экран не ломаем).
  Future<void> loadEspnNews() async {
    if (_fetchCareerStatsForTest != null) {
      _holder.setViewModel(
        _holder.viewModel.copyWith(espnNews: const Loadable.value(value: [])),
      );
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(espnNews: _holder.viewModel.espnNews.toLoading()));
    try {
      final data = await _espnMediaRepository!.constructorNews(
        constructorId: constructor.constructorId,
        constructorName: constructor.name,
      );
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(espnNews: _holder.viewModel.espnNews.toValue(data)),
      );
    } on Object {
      if (_disposed) {
        return;
      }
      _holder.setViewModel(
        _holder.viewModel.copyWith(espnNews: _holder.viewModel.espnNews.toValue(const [])),
      );
    }
  }

  Future<CareerStats<DriverModel>> _fetchCareerStats({
    required String constructorId,
    required List<DriverModel> current,
  }) {
    final forTest = _fetchCareerStatsForTest;
    if (forTest != null) {
      return forTest(constructorId: constructorId, current: current);
    }
    return _careerRepository!.load(constructorId: constructorId, current: current);
  }
}
