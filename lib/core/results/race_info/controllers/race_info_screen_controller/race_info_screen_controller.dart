import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/fetch_from_loader.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/race_info/loaders/pit_stops_loader.dart';
import 'package:f1_pet_project/core/results/race_info/loaders/qualifying_results_loader.dart';
import 'package:f1_pet_project/core/results/race_info/loaders/sprint_results_loader.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/interceptors_functions.dart';
import 'package:mobx/mobx.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'race_info_screen_controller.g.dart';

const _appBarPinOffset = 150.0;

bool _isAppBarPinned(VisibilityInfo info) =>
    info.visibleBounds.top < info.size.height - _appBarPinOffset && info.visibleBounds.right != 0;

/// Секции экрана для управления закреплением шапок таблиц.
enum _RaceInfoSection { race, sprint, qualification, pitStops }

/// MobX-контроллер детального экрана гонки.
class RaceInfoScreenController = RaceInfoScreenControllerBase with _$RaceInfoScreenController;

/// Управляет данными гонки, спринта, квалификации, пит-стопов и закреплением шапок таблиц.
abstract class RaceInfoScreenControllerBase with Store {
  RaceInfoScreenControllerBase({
    required this.raceModel,
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifyingResults,
    Future<ScheduleModel> Function({required String year, required String round})? fetchPitStops,
    Future<ScheduleModel> Function({required String year, required String round})? fetchSprintResults,
  }) : _fetchQualifyingResultsOverride = fetchQualifyingResults,
       _fetchPitStopsOverride = fetchPitStops,
       _fetchSprintResultsOverride = fetchSprintResults;

  final RacesModel raceModel;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifyingResultsOverride;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchPitStopsOverride;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchSprintResultsOverride;

  @observable
  bool raceAppBarPinned = true;

  @observable
  bool sprintAppBarPinned = false;

  @observable
  bool qualificationAppBarPinned = false;

  @observable
  bool pitStopsAppBarPinned = false;

  @observable
  bool allDataIsLoaded = false;

  @observable
  AsyncValue<List<ResultsModel>> sprintResults = const AsyncValue.loading();

  @observable
  AsyncValue<List<QualifyingResultsModel>> qualifyingResults = const AsyncValue.loading();

  @observable
  AsyncValue<List<PitStopsModel>> pitStops = const AsyncValue.loading();

  @computed
  CustomException? get screenError => firstException([sprintResults, qualifyingResults, pitStops]);

  /// Есть ли результаты спринта для отображения.
  bool get hasSprintResults => sprintResults.value?.isNotEmpty ?? false;

  /// Загружает спринт, квалификацию и пит-стопы выбранной гонки.
  @action
  Future<void> loadAllData() async {
    allDataIsLoaded = false;
    await Future.wait([loadSprintResults(), loadQualifyingResults(), loadPitStops()]);
    allDataIsLoaded = screenError == null;
  }

  /// Обновляет закрепление шапки таблицы результатов при прокрутке.
  @action
  void onRaceTableVisibilityChanged(VisibilityInfo info) => _setAppBarPinned(_RaceInfoSection.race, info);

  /// Обновляет закрепление шапки таблицы спринта при прокрутке.
  @action
  void onSprintTableVisibilityChanged(VisibilityInfo info) => _setAppBarPinned(_RaceInfoSection.sprint, info);

  /// Обновляет закрепление шапки таблицы квалификации при прокрутке.
  @action
  void onQualificationTableVisibilityChanged(VisibilityInfo info) =>
      _setAppBarPinned(_RaceInfoSection.qualification, info);

  /// Обновляет закрепление шапки таблицы пит-стопов при прокрутке.
  @action
  void onPitStopsTableVisibilityChanged(VisibilityInfo info) => _setAppBarPinned(_RaceInfoSection.pitStops, info);

  void _setAppBarPinned(_RaceInfoSection section, VisibilityInfo info) {
    final pinned = _isAppBarPinned(info);
    switch (section) {
      case _RaceInfoSection.race:
        raceAppBarPinned = pinned;
      case _RaceInfoSection.sprint:
        sprintAppBarPinned = pinned;
      case _RaceInfoSection.qualification:
        qualificationAppBarPinned = pinned;
      case _RaceInfoSection.pitStops:
        pitStopsAppBarPinned = pinned;
    }
  }

  /// Загружает результаты спринта; на обычном уикенде список будет пустым.
  @action
  Future<void> loadSprintResults() async {
    await runAsyncLoad<ScheduleModel, List<ResultsModel>>(
      fetch: () => _fetchSprintResults(year: raceModel.season, round: raceModel.round),
      getField: () => sprintResults,
      setField: (value) => sprintResults = value,
      onSuccess: (data) {
        if (data!.raceTable.races.isEmpty) {
          sprintResults = sprintResults.toValue([]);
        } else {
          sprintResults = sprintResults.toValue(data.raceTable.races[0].sprintResults ?? []);
        }
      },
    );
  }

  /// Загружает результаты квалификации для текущей гонки.
  @action
  Future<void> loadQualifyingResults() async {
    await runAsyncLoad<ScheduleModel, List<QualifyingResultsModel>>(
      fetch: () => _fetchQualifyingResults(year: raceModel.season, round: raceModel.round),
      getField: () => qualifyingResults,
      setField: (value) => qualifyingResults = value,
      onSuccess: (data) {
        if (data!.raceTable.races.isEmpty) {
          qualifyingResults = qualifyingResults.toValue([]);
        } else {
          qualifyingResults = qualifyingResults.toValue(data.raceTable.races[0].qualifyingResults ?? []);
        }
      },
    );
  }

  /// Загружает пит-стопы и подставляет имена пилотов из уже известных данных гонки.
  @action
  Future<void> loadPitStops() async {
    await runAsyncLoad<ScheduleModel, List<PitStopsModel>>(
      fetch: () => _fetchPitStops(year: raceModel.season, round: raceModel.round),
      getField: () => pitStops,
      setField: (value) => pitStops = value,
      onSuccess: (data) {
        if (data!.raceTable.races.isEmpty) {
          pitStops = pitStops.toValue([]);
        } else {
          final stops = data.raceTable.races[0].pitStops ?? [];
          pitStops = pitStops.toValue(_withDriverNames(stops));
        }
      },
    );
  }

  /// Имена берутся из результатов/квалификации гонки — без отдельных API-запросов на каждого пилота.
  List<PitStopsModel> _withDriverNames(List<PitStopsModel> stops) {
    final names = <String, String>{};

    for (final result in raceModel.results ?? const <ResultsModel>[]) {
      final driver = result.driver;
      names[driver.driverId] = '${driver.givenName} ${driver.familyName}';
    }
    for (final result in raceModel.qualifyingResults ?? const <QualifyingResultsModel>[]) {
      final driver = result.driver;
      names.putIfAbsent(driver.driverId, () => '${driver.givenName} ${driver.familyName}');
    }
    for (final result in sprintResults.value ?? const <ResultsModel>[]) {
      final driver = result.driver;
      names.putIfAbsent(driver.driverId, () => '${driver.givenName} ${driver.familyName}');
    }

    return [
      for (final stop in stops) stop.copyWith(driverId: names[stop.driverId] ?? stop.driverId),
    ];
  }

  Future<ScheduleModel> _fetchSprintResults({required String year, required String round}) {
    final override = _fetchSprintResultsOverride;
    return fetchFromLoader(
      override: override == null ? null : () => override(year: year, round: round),
      load: () => SprintResultsLoader.loadData(year: year, round: round),
      parse: ScheduleModel.fromJson,
      withCache: checkCache,
    );
  }

  Future<ScheduleModel> _fetchQualifyingResults({required String year, required String round}) {
    final override = _fetchQualifyingResultsOverride;
    return fetchFromLoader(
      override: override == null ? null : () => override(year: year, round: round),
      load: () => QualifyingResultsLoader.loadData(year: year, round: round),
      parse: ScheduleModel.fromJson,
      withCache: checkCache,
    );
  }

  Future<ScheduleModel> _fetchPitStops({required String year, required String round}) {
    final override = _fetchPitStopsOverride;
    return fetchFromLoader(
      override: override == null ? null : () => override(year: year, round: round),
      load: () => PitStopsLoader.loadData(year: year, round: round),
      parse: ScheduleModel.fromJson,
      withCache: checkCache,
    );
  }
}
