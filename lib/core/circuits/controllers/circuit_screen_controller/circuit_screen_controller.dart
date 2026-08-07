import 'package:f1_pet_project/common/repositories/wikipedia/wikipedia_page_image_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/core/circuits/stats/circuit_stats_repository.dart';
import 'package:f1_pet_project/core/circuits/stats/models/circuit_stats.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние экрана трассы.
@immutable
class CircuitScreenState {
  const CircuitScreenState({
    this.winners = const Loadable.loading(),
    this.photoUrl = const Loadable.loading(),
    this.stats = const Loadable.loading(),
  });

  final Loadable<List<CircuitRaceWin>> winners;
  final Loadable<String?> photoUrl;
  final Loadable<CircuitStats?> stats;

  CustomException? get screenError => firstException([winners]);

  bool get isLoaded => winners.isValue && winners.value != null;

  bool get isPhotoLoading => photoUrl.isLoading;

  String? get circuitPhotoUrl => photoUrl.value;

  CircuitStats? get circuitStats => stats.value;

  CircuitScreenState copyWith({
    Loadable<List<CircuitRaceWin>>? winners,
    Loadable<String?>? photoUrl,
    Loadable<CircuitStats?>? stats,
  }) {
    return CircuitScreenState(
      winners: winners ?? this.winners,
      photoUrl: photoUrl ?? this.photoUrl,
      stats: stats ?? this.stats,
    );
  }
}

/// Загружает историю побед, stats и фото трассы (Wikipedia).
class CircuitScreenController extends Notifier<CircuitScreenState> {
  CircuitScreenController(
    this.circuit, {
    @visibleForTesting Future<List<CircuitRaceWin>> Function({required String circuitId})? fetchWinnersForTest,
    @visibleForTesting Future<String?> Function(String articleUrl)? fetchPhotoUrlForTest,
    @visibleForTesting Future<CircuitStats?> Function(String circuitId)? fetchStatsForTest,
  }) : _fetchWinnersForTest = fetchWinnersForTest,
       _fetchPhotoUrlForTest = fetchPhotoUrlForTest,
       _fetchStatsForTest = fetchStatsForTest;

  final CircuitModel circuit;
  final Future<List<CircuitRaceWin>> Function({required String circuitId})? _fetchWinnersForTest;
  final Future<String?> Function(String articleUrl)? _fetchPhotoUrlForTest;
  final Future<CircuitStats?> Function(String circuitId)? _fetchStatsForTest;

  CircuitStatsRepository get _statsRepository => ref.read(circuitStatsRepositoryProvider);

  CircuitsRepository? get _circuitsRepository {
    if (_fetchWinnersForTest != null) {
      return null;
    }
    return ref.read(circuitsRepositoryProvider);
  }

  WikipediaPageImageRepository? get _wikipediaRepository {
    if (_fetchPhotoUrlForTest != null) {
      return null;
    }
    return ref.read(wikipediaPageImageRepositoryProvider);
  }

  AppDataRefresh? get _dataRefresh {
    if (_fetchWinnersForTest != null) {
      return null;
    }
    return ref.read(appDataRefreshProvider);
  }

  @override
  CircuitScreenState build() => const CircuitScreenState();

  /// Загружает победителей, stats и фото параллельно.
  Future<void> loadAll() async {
    await Future.wait([loadWinners(), loadPhoto(), loadStats()]);
  }

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка.
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (!ref.mounted) {
      return;
    }
    await loadAll();
  }

  /// Загружает (или перезагружает) список победителей.
  Future<void> loadWinners() async {
    await runAsyncLoad(
      fetch: () => _fetchWinners(circuitId: circuit.circuitId),
      getField: () => state.winners,
      setField: (value) => state = state.copyWith(winners: value),
      onSuccess: (data) {
        if (data != null) {
          state = state.copyWith(winners: state.winners.toValue(data));
        }
      },
    );
  }

  /// Curated stats; ошибка не ломает экран.
  Future<void> loadStats() async {
    state = state.copyWith(stats: state.stats.toLoading());
    try {
      final value = await _fetchStats(circuit.circuitId);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(stats: state.stats.toValue(value));
    } on Object {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(stats: const Loadable.value());
    }
  }

  /// Фото из Wikipedia; ошибка не ломает экран.
  Future<void> loadPhoto() async {
    state = state.copyWith(photoUrl: state.photoUrl.toLoading());
    try {
      final url = await _fetchPhoto(circuit.url);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(photoUrl: state.photoUrl.toValue(url));
    } on Object {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(photoUrl: const Loadable.value());
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

final circuitScreenControllerProvider =
    NotifierProvider.autoDispose.family<CircuitScreenController, CircuitScreenState, CircuitModel>(
      CircuitScreenController.new,
    );
