import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/offline_cached_banner.dart';
import 'package:f1_pet_project/core/results/repositories/results_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние экрана результатов.
@immutable
class ResultsState {
  const ResultsState({this.lastRace = const Loadable.loading(), this.showingCachedData = false});

  final Loadable<RacesModel> lastRace;

  /// Офлайн + есть кэш last race / scoreboard.
  final bool showingCachedData;

  CustomException? get screenError => lastRace.exception;

  ResultsState copyWith({Loadable<RacesModel>? lastRace, bool? showingCachedData}) {
    return ResultsState(
      lastRace: lastRace ?? this.lastRace,
      showingCachedData: showingCachedData ?? this.showingCachedData,
    );
  }
}

/// Управляет загрузкой результатов последней гонки; scoreboard — через [LiveWeekendController].
class ResultsScreenController extends Notifier<ResultsState> {
  ResultsScreenController({
    @visibleForTesting Future<ScheduleModel> Function()? fetchLastRaceResultsForTest,
    @visibleForTesting AppDataRefresh? dataRefreshForTest,
  }) : _fetchLastRaceResultsForTest = fetchLastRaceResultsForTest,
       _dataRefreshForTest = dataRefreshForTest;

  final Future<ScheduleModel> Function()? _fetchLastRaceResultsForTest;
  final AppDataRefresh? _dataRefreshForTest;

  ResultsRepository get _resultsRepository => ref.read(resultsRepositoryProvider);

  @override
  ResultsState build() => const ResultsState();

  /// Загружает последнюю гонку (scoreboard уже грузит [LiveWeekendController]).
  Future<void> loadAllData() async {
    await loadLastRaceResults();
    await _syncOfflineBanner();
  }

  /// Pull-to-refresh: единый сброс кэшей и принудительная перезагрузка.
  Future<void> refreshAll() async {
    if (_dataRefreshForTest != null) {
      await _dataRefreshForTest.clearAll();
    } else if (_fetchLastRaceResultsForTest == null) {
      await ref.read(appDataRefreshProvider).clearAll();
    }
    await Future.wait([
      loadLastRaceResults(),
      ref.read(liveWeekendControllerProvider.notifier).loadScoreboard(forceRefresh: true),
    ]);
    await _syncOfflineBanner();
  }

  /// Запрашивает результаты последней завершённой гонки.
  Future<void> loadLastRaceResults() async {
    await runAsyncLoad<ScheduleModel, RacesModel>(
      fetch: _fetchLastRaceResults,
      getField: () => state.lastRace,
      setField: (value) => state = state.copyWith(lastRace: value),
      onSuccess: (data) => state = state.copyWith(lastRace: state.lastRace.toValue(data!.raceTable.races[0])),
    );
  }

  Future<void> _syncOfflineBanner() async {
    final hasScoreboard = ref.read(liveWeekendControllerProvider).scoreboard.isValue;
    final showing = await shouldShowOfflineCachedBanner(hasCachedContent: state.lastRace.isValue || hasScoreboard);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(showingCachedData: showing);
  }

  /// После появления сети — спрятать баннер без перезагрузки.
  Future<void> dismissOfflineBannerIfOnline() async {
    final showing = await clearOfflineBannerIfOnline(currentlyShowing: state.showingCachedData);
    if (!ref.mounted) {
      return;
    }
    state = state.copyWith(showingCachedData: showing);
  }

  Future<ScheduleModel> _fetchLastRaceResults() {
    final forTest = _fetchLastRaceResultsForTest;
    if (forTest != null) {
      return forTest();
    }
    return _resultsRepository.lastRace();
  }
}

final resultsScreenControllerProvider = NotifierProvider.autoDispose<ResultsScreenController, ResultsState>(
  ResultsScreenController.new,
);
