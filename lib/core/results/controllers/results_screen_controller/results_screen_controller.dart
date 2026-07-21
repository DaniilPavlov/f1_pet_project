import 'dart:async';

import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/fetch_from_loader.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/espn/loaders/espn_scoreboard_loader.dart';
import 'package:f1_pet_project/core/espn/models/espn_scoreboard_models.dart';
import 'package:f1_pet_project/core/results/loaders/last_race_results_loader.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/request_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'results_screen_controller.g.dart';

/// MobX-контроллер экрана результатов.
class ResultsScreenController = ResultsScreenControllerBase with _$ResultsScreenController;

/// Управляет загрузкой результатов последней гонки и ESPN scoreboard.
abstract class ResultsScreenControllerBase with Store {
  ResultsScreenControllerBase({
    Future<ScheduleModel> Function()? fetchLastRaceResults,
    Future<EspnScoreboardEvent?> Function()? fetchScoreboard,
  }) : _fetchLastRaceResultsOverride = fetchLastRaceResults,
       _fetchScoreboardOverride = fetchScoreboard;

  final Future<ScheduleModel> Function()? _fetchLastRaceResultsOverride;
  final Future<EspnScoreboardEvent?> Function()? _fetchScoreboardOverride;

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

  /// Pull-to-refresh: сброс кэшей и принудительная перезагрузка.
  @action
  Future<void> refreshAll() async {
    RequestHandler().clearCache();
    await Future.wait([
      loadLastRaceResults(),
      loadScoreboard(forceRefresh: true),
    ]);
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
    final useSharedCache = _fetchScoreboardOverride == null;
    if (useSharedCache && !forceRefresh) {
      final cached = EspnScoreboardLoader.peek;
      if (EspnScoreboardLoader.isFresh) {
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
      debugPrint('ResultsScreenController.loadScoreboard failed: $error\n$stackTrace');
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

  Future<ScheduleModel> _fetchLastRaceResults() => fetchFromLoader(
    override: _fetchLastRaceResultsOverride,
    load: LastRaceResultsLoader.loadData,
    parse: ScheduleModel.fromJson,
  );

  Future<EspnScoreboardEvent?> _fetchScoreboard({bool forceRefresh = false}) {
    final override = _fetchScoreboardOverride;
    if (override != null) {
      return override();
    }
    return EspnScoreboardLoader.loadEvent(forceRefresh: forceRefresh);
  }
}
