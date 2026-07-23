import 'package:f1_pet_project/common/repositories/wikipedia/wikipedia_page_image_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/core/circuits/stats/circuit_stats_repository.dart';
import 'package:f1_pet_project/core/circuits/stats/models/circuit_stats.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'circuit_screen_controller.g.dart';

/// MobX-контроллер экрана трассы.
class CircuitScreenController = CircuitScreenControllerBase with _$CircuitScreenController;

/// Загружает историю побед, stats и фото трассы (Wikipedia).
abstract class CircuitScreenControllerBase with Store {
  CircuitScreenControllerBase({
    required this.circuit,
    required CircuitStatsRepository statsRepository,
    CircuitsRepository? circuitsRepository,
    WikipediaPageImageRepository? wikipediaRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<List<CircuitRaceWin>> Function({required String circuitId})? fetchWinnersForTest,
    @visibleForTesting Future<String?> Function(String articleUrl)? fetchPhotoUrlForTest,
    @visibleForTesting Future<CircuitStats?> Function(String circuitId)? fetchStatsForTest,
  }) : _statsRepository = statsRepository,
       _circuitsRepository = circuitsRepository,
       _wikipediaRepository = wikipediaRepository,
       _dataRefresh = dataRefresh,
       _fetchWinnersForTest = fetchWinnersForTest,
       _fetchPhotoUrlForTest = fetchPhotoUrlForTest,
       _fetchStatsForTest = fetchStatsForTest;

  final CircuitModel circuit;
  final CircuitStatsRepository _statsRepository;
  final CircuitsRepository? _circuitsRepository;
  final WikipediaPageImageRepository? _wikipediaRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<List<CircuitRaceWin>> Function({required String circuitId})? _fetchWinnersForTest;
  final Future<String?> Function(String articleUrl)? _fetchPhotoUrlForTest;
  final Future<CircuitStats?> Function(String circuitId)? _fetchStatsForTest;
  @observable
  AsyncValue<List<CircuitRaceWin>> winners = const AsyncValue.loading();

  @observable
  AsyncValue<String?> photoUrl = const AsyncValue.loading();

  @observable
  AsyncValue<CircuitStats?> stats = const AsyncValue.loading();

  @computed
  CustomException? get screenError => firstException([winners]);

  @computed
  bool get isLoaded => winners.isValue && winners.value != null;

  @computed
  bool get isPhotoLoading => photoUrl.isLoading;

  @computed
  String? get circuitPhotoUrl => photoUrl.value;

  @computed
  CircuitStats? get circuitStats => stats.value;

  /// Загружает победителей, stats и фото параллельно.
  @action
  Future<void> loadAll() async {
    await Future.wait([loadWinners(), loadPhoto(), loadStats()]);
  }

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка.
  @action
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await loadAll();
  }

  /// Загружает (или перезагружает) список победителей.
  @action
  Future<void> loadWinners() async {
    await runAsyncLoad(
      fetch: () => _fetchWinners(circuitId: circuit.circuitId),
      getField: () => winners,
      setField: (value) => winners = value,
      onSuccess: (data) {
        if (data != null) {
          winners = winners.toValue(data);
        }
      },
    );
  }

  /// Curated stats; ошибка не ломает экран.
  @action
  Future<void> loadStats() async {
    stats = stats.toLoading();
    try {
      final value = await _fetchStats(circuit.circuitId);
      stats = stats.toValue(value);
    } on Object {
      stats = const AsyncValue.value();
    }
  }

  /// Фото из Wikipedia; ошибка не ломает экран.
  @action
  Future<void> loadPhoto() async {
    photoUrl = photoUrl.toLoading();
    try {
      final url = await _fetchPhoto(circuit.url);
      photoUrl = photoUrl.toValue(url);
    } on Object {
      photoUrl = const AsyncValue.value();
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
    return _statsRepository.of(circuitId);
  }
}
