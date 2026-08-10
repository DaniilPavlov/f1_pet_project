import 'package:f1_pet_project/common/repositories/wikipedia/wikipedia_page_image_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/core/circuits/state/state_holders/circuit_page_state_holder.dart';
import 'package:f1_pet_project/core/circuits/stats/circuit_stats_repository.dart';
import 'package:f1_pet_project/core/circuits/stats/models/circuit_stats.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';

/// Загружает историю побед, stats и фото трассы (Wikipedia).
class CircuitPageManager {
  CircuitPageManager({
    required this.circuit,
    required CircuitPageStateHolder holder,
    CircuitsRepository? circuitsRepository,
    WikipediaPageImageRepository? wikipediaRepository,
    CircuitStatsRepository? statsRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<List<CircuitRaceWin>> Function({required String circuitId})? fetchWinnersForTest,
    @visibleForTesting Future<String?> Function(String articleUrl)? fetchPhotoUrlForTest,
    @visibleForTesting Future<CircuitStats?> Function(String circuitId)? fetchStatsForTest,
  }) : _holder = holder,
       _circuitsRepository = circuitsRepository,
       _wikipediaRepository = wikipediaRepository,
       _statsRepository = statsRepository,
       _dataRefresh = dataRefresh,
       _fetchWinnersForTest = fetchWinnersForTest,
       _fetchPhotoUrlForTest = fetchPhotoUrlForTest,
       _fetchStatsForTest = fetchStatsForTest;

  /// Текущая трасса для которой загружаются данные.
  final CircuitModel circuit;
  final CircuitPageStateHolder _holder;
  final CircuitsRepository? _circuitsRepository;
  final WikipediaPageImageRepository? _wikipediaRepository;
  final CircuitStatsRepository? _statsRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<List<CircuitRaceWin>> Function({required String circuitId})? _fetchWinnersForTest;
  final Future<String?> Function(String articleUrl)? _fetchPhotoUrlForTest;
  final Future<CircuitStats?> Function(String circuitId)? _fetchStatsForTest;

  /// Загружает победителей, stats и фото параллельно.
  Future<void> loadAll() async {
    await Future.wait([loadWinners(), loadPhoto(), loadStats()]);
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await loadAll();
  }

  /// Загружает (или перезагружает) список победителей.
  Future<void> loadWinners() async {
    await runAsyncLoad(
      fetch: () => _fetchWinners(circuitId: circuit.circuitId),
      getField: () => _holder.viewModel.winners,
      setField: (value) => _holder.setViewModel(_holder.viewModel.copyWith(winners: value)),
      onSuccess: (data) {
        if (data != null) {
          _holder.setViewModel(
            _holder.viewModel.copyWith(winners: _holder.viewModel.winners.toValue(data)),
          );
        }
      },
    );
  }

  /// Curated stats; ошибка не ломает экран.
  Future<void> loadStats() async {
    _holder.setViewModel(_holder.viewModel.copyWith(stats: _holder.viewModel.stats.toLoading()));
    try {
      final value = await _fetchStats(circuit.circuitId);
      _holder.setViewModel(_holder.viewModel.copyWith(stats: _holder.viewModel.stats.toValue(value)));
    } on Object {
      _holder.setViewModel(_holder.viewModel.copyWith(stats: const Loadable.value()));
    }
  }

  /// Фото из Wikipedia; ошибка не ломает экран.
  Future<void> loadPhoto() async {
    _holder.setViewModel(_holder.viewModel.copyWith(photoUrl: _holder.viewModel.photoUrl.toLoading()));
    try {
      final url = await _fetchPhoto(circuit.url);
      _holder.setViewModel(_holder.viewModel.copyWith(photoUrl: _holder.viewModel.photoUrl.toValue(url)));
    } on Object {
      _holder.setViewModel(_holder.viewModel.copyWith(photoUrl: const Loadable.value()));
    }
  }

  Future<List<CircuitRaceWin>> _fetchWinners({required String circuitId}) {
    final forTest = _fetchWinnersForTest;
    if (forTest != null) {
      return forTest(circuitId: circuitId);
    }
    return _circuitsRepository!.winners(circuitId: circuitId);
  }

  Future<String?> _fetchPhoto(String articleUrl) {
    final forTest = _fetchPhotoUrlForTest;
    if (forTest != null) {
      return forTest(articleUrl);
    }
    return _wikipediaRepository!.loadThumbnail(articleUrl: articleUrl);
  }

  Future<CircuitStats?> _fetchStats(String circuitId) {
    final forTest = _fetchStatsForTest;
    if (forTest != null) {
      return forTest(circuitId);
    }
    return _statsRepository!.of(circuitId);
  }
}
