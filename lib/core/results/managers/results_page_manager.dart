import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/offline_cached_banner.dart';
import 'package:f1_pet_project/core/results/repositories/results_repository.dart';
import 'package:f1_pet_project/core/results/state/state_holders/results_page_state_holder.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:flutter/foundation.dart';

/// Загружает результаты последней гонки; scoreboard — через [LiveWeekendController].
class ResultsPageManager {
  ResultsPageManager({
    required ResultsPageStateHolder holder,
    ResultsRepository? resultsRepository,
    AppDataRefresh? dataRefresh,
    LiveWeekendController? liveWeekend,
    bool Function()? scoreboardIsValue,
    @visibleForTesting Future<ScheduleModel> Function()? fetchLastRaceResultsForTest,
    @visibleForTesting Future<void> Function({bool forceRefresh})? loadScoreboardForTest,
  }) : _holder = holder,
       _resultsRepository = resultsRepository,
       _dataRefresh = dataRefresh,
       _liveWeekend = liveWeekend,
       _scoreboardIsValue = scoreboardIsValue,
       _fetchLastRaceResultsForTest = fetchLastRaceResultsForTest,
       _loadScoreboardForTest = loadScoreboardForTest;

  final ResultsPageStateHolder _holder;
  final ResultsRepository? _resultsRepository;
  final AppDataRefresh? _dataRefresh;
  final LiveWeekendController? _liveWeekend;
  final bool Function()? _scoreboardIsValue;
  final Future<ScheduleModel> Function()? _fetchLastRaceResultsForTest;
  final Future<void> Function({bool forceRefresh})? _loadScoreboardForTest;

  var _disposed = false;

  /// Загружает последнюю гонку (scoreboard уже грузит [LiveWeekendController]).
  Future<void> loadAllData() async {
    await loadLastRaceResults();
    await _syncOfflineBanner();
  }

  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    if (_disposed) {
      return;
    }
    await Future.wait([
      loadLastRaceResults(),
      _reloadScoreboard(forceRefresh: true),
    ]);
    await _syncOfflineBanner();
  }

  /// Запрашивает результаты последней завершённой гонки.
  Future<void> loadLastRaceResults() async {
    await runAsyncLoad<ScheduleModel, RacesModel>(
      fetch: _fetchLastRaceResults,
      getField: () => _holder.viewModel.lastRace,
      setField: (value) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(_holder.viewModel.copyWith(lastRace: value));
      },
      onSuccess: (data) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(
          _holder.viewModel.copyWith(lastRace: _holder.viewModel.lastRace.toValue(data!.raceTable.races[0])),
        );
      },
    );
  }

  /// После появления сети — спрятать баннер без перезагрузки.
  Future<void> dismissOfflineBannerIfOnline() async {
    final showing = await clearOfflineBannerIfOnline(currentlyShowing: _holder.viewModel.showingCachedData);
    if (_disposed) {
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(showingCachedData: showing));
  }

  /// Очищает ресурсы менеджера.
  void dispose() {
    _disposed = true;
  }

  Future<void> _syncOfflineBanner() async {
    final hasScoreboard = _scoreboardIsValue?.call() ?? false;
    final showing = await shouldShowOfflineCachedBanner(
      hasCachedContent: _holder.viewModel.lastRace.isValue || hasScoreboard,
    );
    if (_disposed) {
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(showingCachedData: showing));
  }

  Future<void> _reloadScoreboard({required bool forceRefresh}) {
    final forTest = _loadScoreboardForTest;
    if (forTest != null) {
      return forTest(forceRefresh: forceRefresh);
    }
    return _liveWeekend!.loadScoreboard(forceRefresh: forceRefresh);
  }

  Future<ScheduleModel> _fetchLastRaceResults() {
    final forTest = _fetchLastRaceResultsForTest;
    if (forTest != null) {
      return forTest();
    }
    return _resultsRepository!.lastRace();
  }
}
