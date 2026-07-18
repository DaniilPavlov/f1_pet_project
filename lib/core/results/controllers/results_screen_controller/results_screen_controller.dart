import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/fetch_from_loader.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/loaders/last_race_results_loader.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:mobx/mobx.dart';

part 'results_screen_controller.g.dart';

/// MobX-контроллер экрана результатов.
class ResultsScreenController = ResultsScreenControllerBase with _$ResultsScreenController;

/// Управляет загрузкой результатов последней гонки.
abstract class ResultsScreenControllerBase with Store {
  ResultsScreenControllerBase({Future<ScheduleModel> Function()? fetchLastRaceResults})
    : _fetchLastRaceResultsOverride = fetchLastRaceResults;

  final Future<ScheduleModel> Function()? _fetchLastRaceResultsOverride;

  @observable
  AsyncValue<RacesModel> lastRace = const AsyncValue.loading();

  @computed
  CustomException? get screenError => lastRace.exception;

  /// Загружает все данные экрана.
  @action
  Future<void> loadAllData() async {
    await loadLastRaceResults();
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

  Future<ScheduleModel> _fetchLastRaceResults() => fetchFromLoader(
    override: _fetchLastRaceResultsOverride,
    load: LastRaceResultsLoader.loadData,
    parse: ScheduleModel.fromJson,
  );
}
