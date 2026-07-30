import 'dart:async';

import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

part 'live_weekend_controller.g.dart';

/// App-level ESPN scoreboard + live polling (не привязан к Results tab).
class LiveWeekendController = LiveWeekendControllerBase with _$LiveWeekendController;

/// Загрузка scoreboard и 30s poll, пока сессия live и приложение на переднем плане.
abstract class LiveWeekendControllerBase with Store {
  LiveWeekendControllerBase({
    EspnScoreboardRepository? scoreboardRepository,
    @visibleForTesting Future<EspnScoreboardEvent?> Function({bool forceRefresh})? fetchScoreboardForTest,
    @visibleForTesting Duration? pollIntervalForTest,
  }) : assert(
         scoreboardRepository != null || fetchScoreboardForTest != null,
         'Provide scoreboardRepository or fetchScoreboardForTest',
       ),
       _scoreboardRepository = scoreboardRepository,
       _fetchScoreboardForTest = fetchScoreboardForTest,
       _pollInterval = pollIntervalForTest ?? StaticData.espnScoreboardPollInterval;

  final EspnScoreboardRepository? _scoreboardRepository;
  final Future<EspnScoreboardEvent?> Function({bool forceRefresh})? _fetchScoreboardForTest;
  final Duration _pollInterval;

  Timer? _pollTimer;
  var _appInForeground = true;

  @observable
  AsyncValue<EspnScoreboardEvent?> scoreboard = const AsyncValue.loading();

  @computed
  bool get isLive => scoreboard.value?.isLive ?? false;

  /// Аббревиатура live-сессии (или highlighted, если event live).
  @computed
  String? get liveSessionAbbreviation {
    final event = scoreboard.value;
    if (event == null || !event.isLive) {
      return null;
    }
    final highlighted = event.highlightedSession;
    if (highlighted != null && highlighted.abbreviation.isNotEmpty) {
      return highlighted.abbreviation;
    }
    return null;
  }

  /// ESPN scoreboard: кэш → сразу; ошибка сети не роняет UI.
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
      logger.e('LiveWeekendController.loadScoreboard failed', error: error, stackTrace: stackTrace);
      if (!scoreboard.isValue) {
        scoreboard = scoreboard.toValue(null);
      }
    } finally {
      _syncLivePolling();
    }
  }

  /// Пауза poll в фоне; на resume — refresh и снова sync.
  void onAppLifecycleChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _appInForeground = true;
        unawaited(loadScoreboard(forceRefresh: true));
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _appInForeground = false;
        stopLivePolling();
    }
  }

  void _syncLivePolling() {
    if (isLive && _appInForeground) {
      _startLivePolling();
    } else {
      stopLivePolling();
    }
  }

  void _startLivePolling() {
    if (_pollTimer != null) {
      return;
    }
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      if (!isLive || !_appInForeground) {
        stopLivePolling();
        return;
      }
      unawaited(loadScoreboard(forceRefresh: true));
    });
  }

  /// Останавливает live-polling.
  void stopLivePolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  /// Для тестов: есть ли активный poll-таймер.
  @visibleForTesting
  bool get isPollingForTest => _pollTimer != null;

  /// Dispose контроллера.
  void dispose() => stopLivePolling();

  Future<EspnScoreboardEvent?> _fetchScoreboard({bool forceRefresh = false}) {
    final forTest = _fetchScoreboardForTest;
    if (forTest != null) {
      return forTest(forceRefresh: forceRefresh);
    }
    return _scoreboardRepository!.loadEvent(forceRefresh: forceRefresh);
  }
}
