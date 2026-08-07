import 'dart:async';

import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/loggers/logger.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние ESPN scoreboard + live polling.
@immutable
class LiveWeekendState {
  const LiveWeekendState({
    this.scoreboard = const Loadable.loading(),
  });

  final Loadable<EspnScoreboardEvent?> scoreboard;

  bool get isLive => scoreboard.value?.isLive ?? false;

  /// Аббревиатура live-сессии (или highlighted, если event live).
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

  LiveWeekendState copyWith({Loadable<EspnScoreboardEvent?>? scoreboard}) {
    return LiveWeekendState(scoreboard: scoreboard ?? this.scoreboard);
  }
}

/// App-level ESPN scoreboard + live polling (не привязан к Results tab).
class LiveWeekendController extends Notifier<LiveWeekendState> {
  LiveWeekendController({
    @visibleForTesting Future<EspnScoreboardEvent?> Function({bool forceRefresh})? fetchScoreboardForTest,
    @visibleForTesting Duration? pollIntervalForTest,
  }) : _fetchScoreboardForTest = fetchScoreboardForTest,
       _pollIntervalForTest = pollIntervalForTest;

  final Future<EspnScoreboardEvent?> Function({bool forceRefresh})? _fetchScoreboardForTest;
  final Duration? _pollIntervalForTest;

  Timer? _pollTimer;
  var _appInForeground = true;

  Duration get _pollInterval => _pollIntervalForTest ?? StaticData.espnScoreboardPollInterval;

  EspnScoreboardRepository? get _scoreboardRepository {
    if (_fetchScoreboardForTest != null) {
      return null;
    }
    return ref.read(espnScoreboardRepositoryProvider);
  }

  @override
  LiveWeekendState build() {
    ref.onDispose(stopLivePolling);
    return const LiveWeekendState();
  }

  /// ESPN scoreboard: кэш → сразу; ошибка сети не роняет UI.
  Future<void> loadScoreboard({bool forceRefresh = false}) async {
    final scoreboardRepository = _scoreboardRepository;
    final useSharedCache = _fetchScoreboardForTest == null && scoreboardRepository != null;
    var scoreboard = state.scoreboard;
    if (useSharedCache && !forceRefresh) {
      final cached = scoreboardRepository.peek;
      if (scoreboardRepository.isFresh) {
        state = state.copyWith(scoreboard: scoreboard.toValue(cached));
        _syncLivePolling();
        return;
      }
      if (cached != null) {
        scoreboard = scoreboard.toValue(cached);
      } else {
        scoreboard = scoreboard.toLoading();
      }
      state = state.copyWith(scoreboard: scoreboard);
    } else if (!scoreboard.isValue) {
      state = state.copyWith(scoreboard: scoreboard.toLoading());
    }

    try {
      final event = await _fetchScoreboard(forceRefresh: forceRefresh);
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(scoreboard: state.scoreboard.toValue(event));
    } on Object catch (error, stackTrace) {
      logger.e('LiveWeekendController.loadScoreboard failed', error: error, stackTrace: stackTrace);
      if (!ref.mounted) {
        return;
      }
      if (!state.scoreboard.isValue) {
        state = state.copyWith(scoreboard: state.scoreboard.toValue(null));
      }
    } finally {
      if (ref.mounted) {
        _syncLivePolling();
      }
    }
  }

  /// Пауза poll в фоне; на resume — refresh и снова sync.
  void onAppLifecycleChanged(AppLifecycleState lifecycleState) {
    switch (lifecycleState) {
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
    if (state.isLive && _appInForeground) {
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
      if (!state.isLive || !_appInForeground) {
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

  Future<EspnScoreboardEvent?> _fetchScoreboard({bool forceRefresh = false}) {
    final forTest = _fetchScoreboardForTest;
    if (forTest != null) {
      return forTest(forceRefresh: forceRefresh);
    }
    return _scoreboardRepository!.loadEvent(forceRefresh: forceRefresh);
  }
}

final liveWeekendControllerProvider = NotifierProvider<LiveWeekendController, LiveWeekendState>(
  LiveWeekendController.new,
);
