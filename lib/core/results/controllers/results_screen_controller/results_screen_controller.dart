import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/repositories/results_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'results_screen_controller.g.dart';

/// MobX-контроллер экрана результатов.
class ResultsScreenController = ResultsScreenControllerBase with _$ResultsScreenController;

/// Управляет загрузкой результатов последней гонки; scoreboard — через [LiveWeekendController].
abstract class ResultsScreenControllerBase with Store {
  ResultsScreenControllerBase({
    ResultsRepository? resultsRepository,
    LiveWeekendController? liveWeekend,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<ScheduleModel> Function()? fetchLastRaceResultsForTest,
  }) : _resultsRepository = resultsRepository,
       _liveWeekend = liveWeekend,
       _dataRefresh = dataRefresh,
       _fetchLastRaceResultsForTest = fetchLastRaceResultsForTest;

  final ResultsRepository? _resultsRepository;
  final LiveWeekendController? _liveWeekend;
  final AppDataRefresh? _dataRefresh;
  final Future<ScheduleModel> Function()? _fetchLastRaceResultsForTest;

  @observable
  AsyncValue<RacesModel> lastRace = const AsyncValue.loading();

  @computed
  CustomException? get screenError => lastRace.exception;

  /// Загружает последнюю гонку (scoreboard уже грузит [LiveWeekendController]).
  @action
  Future<void> loadAllData() async {
    await loadLastRaceResults();
  }

  /// Pull-to-refresh: единый сброс кэшей и принудительная перезагрузка.
  @action
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await Future.wait([
      loadLastRaceResults(),
      if (_liveWeekend != null) _liveWeekend.loadScoreboard(forceRefresh: true),
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

  Future<ScheduleModel> _fetchLastRaceResults() {
    final forTest = _fetchLastRaceResultsForTest;
    if (forTest != null) {
      return forTest();
    }
    return _resultsRepository!.lastRace();
  }
}
