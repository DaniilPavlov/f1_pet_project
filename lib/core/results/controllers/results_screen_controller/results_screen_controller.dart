import 'dart:async';

import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/core/espn/models/espn_scoreboard_models.dart';
import 'package:f1_pet_project/core/espn/repositories/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/core/results/repositories/results_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'results_screen_controller.g.dart';

/// MobX-контроллер экрана результатов.
class ResultsScreenController = ResultsScreenControllerBase with _$ResultsScreenController;

/// Управляет загрузкой результатов последней гонки и ESPN scoreboard.
abstract class ResultsScreenControllerBase with Store {
  ResultsScreenControllerBase({
    ResultsRepository? resultsRepository,
    EspnScoreboardRepository? scoreboardRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<ScheduleModel> Function()? fetchLastRaceResultsForTest,
    @visibleForTesting Future<EspnScoreboardEvent?> Function()? fetchScoreboardForTest,
  }) : _resultsRepository = resultsRepository,
       _scoreboardRepository = scoreboardRepository,
       _dataRefresh = dataRefresh,
       _fetchLastRaceResultsForTest = fetchLastRaceResultsForTest,
       _fetchScoreboardForTest = fetchScoreboardForTest;

  final ResultsRepository? _resultsRepository;
  final EspnScoreboardRepository? _scoreboardRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<ScheduleModel> Function()? _fetchLastRaceResultsForTest;
  final Future<EspnScoreboardEvent?> Function()? _fetchScoreboardForTest;

  Timer? _pollTimer;

  @observable
  AsyncValue<RacesModel> lastRace = const AsyncValue.loading();

  @observable
  AsyncValue<EspnScoreboardEvent?> scoreboard = const AsyncValue.loading();

  @computed
  CustomException? get screenError => lastRace.exception;

  @computed
  bool get isScoreboardLive => scoreboard.value?.isLive ?? false;

  /// Загружает последнюю гонку и ESPN scoreboard параллельно.
  @action
  Future<void> loadAllData() async {
    await Future.wait([loadLastRaceResults(), loadScoreboard()]);
  }

  /// Pull-to-refresh: единый сброс кэшей и принудительная перезагрузка.
  @action
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await Future.wait([loadLastRaceResults(), loadScoreboard(forceRefresh: true)]);
  }

  /// Запрашивает результаты последней завершённой гонки.
  @action
  Future<void> loadLastRaceResults() async {
    await runAsyncLoad<ScheduleModel, RacesModel>(
      fetch: _fetchLastRaceResults,
      getField: () => lastRace,
      setField: (value) => lastRace = value,
      onSuccess: (data) => lastRace = lastRace.toValue(data!.raceTable.races[0]),
    );
  }

  /// ESPN scoreboard: кэш → сразу на экран; ошибка сети не ломает Results.
  @action
  Future<void> loadScoreboard({bool forceRefresh = false}) async {
    final scoreboardRepository = _scoreboardRepository;
    final useSharedCache = _fetchScoreboardForTest == null && scoreboardRepository != null;
    if (useSharedCache && !forceRefresh) {
      final cached = scoreboardRepository.peek;
      if (scoreboardRepository.isFresh) {
        scoreboard = scoreboard.toValue(cached);
        _syncLivePolling();
        return;
      }
      if (cached != null) {
        scoreboard = scoreboard.toValue(cached);
      } else {
        scoreboard = scoreboard.toLoading();
      }
    } else if (!scoreboard.isValue) {
      scoreboard = scoreboard.toLoading();
    }

    try {
      final event = await _fetchScoreboard(forceRefresh: forceRefresh);
      scoreboard = scoreboard.toValue(event);
    } on Object catch (error, stackTrace) {
      logger.e('ResultsScreenController.loadScoreboard failed', error: error, stackTrace: stackTrace);
      if (!scoreboard.isValue) {
        scoreboard = scoreboard.toValue(null);
      }
    } finally {
      _syncLivePolling();
    }
  }

  void _syncLivePolling() {
    if (isScoreboardLive) {
      _startLivePolling();
    } else {
      stopLivePolling();
    }
  }

  void _startLivePolling() {
    if (_pollTimer != null) {
      return;
    }
    _pollTimer = Timer.periodic(StaticData.espnScoreboardPollInterval, (_) {
      if (!isScoreboardLive) {
        stopLivePolling();
        return;
      }
      unawaited(loadScoreboard(forceRefresh: true));
    });
  }

  /// Останавливает live-polling (при уходе с экрана / конце сессии).
  void stopLivePolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// Dispose контроллера.
  void dispose() => stopLivePolling();

  Future<ScheduleModel> _fetchLastRaceResults() {
    final forTest = _fetchLastRaceResultsForTest;
    if (forTest != null) {
      return forTest();
    }
    return _resultsRepository!.lastRace();
  }

  Future<EspnScoreboardEvent?> _fetchScoreboard({bool forceRefresh = false}) {
    final forTest = _fetchScoreboardForTest;
    if (forTest != null) {
      return forTest();
    }
    return _scoreboardRepository!.loadEvent(forceRefresh: forceRefresh);
  }
}
