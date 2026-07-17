import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/fetch_from_loader.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/models/driver/driver_fetching_model.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/race_info/loaders/driver_loader.dart';
import 'package:f1_pet_project/core/results/race_info/loaders/pit_stops_loader.dart';
import 'package:f1_pet_project/core/results/race_info/loaders/qualifying_results_loader.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/services/executor.dart';
import 'package:f1_pet_project/services/interceptors_functions.dart';
import 'package:mobx/mobx.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'race_info_screen_controller.g.dart';

const _appBarPinOffset = 150.0;

bool _isAppBarPinned(VisibilityInfo info) =>
    info.visibleBounds.top < info.size.height - _appBarPinOffset && info.visibleBounds.right != 0;

/// Секции экрана для управления закреплением шапок таблиц.
enum _RaceInfoSection { race, qualification, pitStops }

/// MobX-контроллер детального экрана гонки.
class RaceInfoScreenController = RaceInfoScreenControllerBase with _$RaceInfoScreenController;

/// Управляет данными гонки, квалификации, пит-стопов и закреплением шапок таблиц.
abstract class RaceInfoScreenControllerBase with Store {
  RaceInfoScreenControllerBase({
    required this.raceModel,
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifyingResults,
    Future<ScheduleModel> Function({required String year, required String round})? fetchPitStops,
    Future<DriverFetchingModel> Function({required String driverId})? fetchDriverInfo,
  }) : _fetchQualifyingResultsOverride = fetchQualifyingResults,
       _fetchPitStopsOverride = fetchPitStops,
       _fetchDriverInfoOverride = fetchDriverInfo;

  final RacesModel raceModel;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchQualifyingResultsOverride;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchPitStopsOverride;
  final Future<DriverFetchingModel> Function({required String driverId})? _fetchDriverInfoOverride;

  @observable
  bool raceAppBarPinned = true;

  @observable
  bool qualificationAppBarPinned = false;

  @observable
  bool pitStopsAppBarPinned = false;

  @observable
  bool allDataIsLoaded = false;

  @observable
  AsyncValue<List<QualifyingResultsModel>> qualifyingResults = const AsyncValue.loading();

  @observable
  AsyncValue<List<PitStopsModel>> pitStops = const AsyncValue.loading();

  @computed
  CustomException? get screenError => firstException([qualifyingResults, pitStops]);

  /// Загружает квалификацию и пит-стопы выбранной гонки.
  @action
  Future<void> loadAllData() async {
    allDataIsLoaded = false;
    await Future.wait([loadQualifyingResults(), loadPitStops()]);
    allDataIsLoaded = screenError == null;
  }

  /// Обновляет закрепление шапки таблицы результатов при прокрутке.
  @action
  void onRaceTableVisibilityChanged(VisibilityInfo info) => _setAppBarPinned(_RaceInfoSection.race, info);

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
      case _RaceInfoSection.qualification:
        qualificationAppBarPinned = pinned;
      case _RaceInfoSection.pitStops:
        pitStopsAppBarPinned = pinned;
    }
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

  /// Загружает пит-стопы и подставляет имена пилотов.
  @action
  Future<void> loadPitStops() async {
    var stops = <PitStopsModel>[];

    await runAsyncLoad<ScheduleModel, List<PitStopsModel>>(
      fetch: () => _fetchPitStops(year: raceModel.season, round: raceModel.round),
      getField: () => pitStops,
      setField: (value) => pitStops = value,
      onSuccess: (data) {
        if (data!.raceTable.races.isEmpty) {
          stops = [];
          pitStops = pitStops.toValue([]);
        } else {
          stops = data.raceTable.races[0].pitStops ?? [];
        }
      },
    );

    if (pitStops.isError) {
      return;
    }
    if (stops.isEmpty) {
      pitStops = pitStops.toValue([]);
      return;
    }

    await _resolveDriverNames(stops);
  }

  Future<void> _resolveDriverNames(List<PitStopsModel> stops) async {
    final resolved = List<PitStopsModel>.from(stops);
    CustomException? resolveError;

    await Future.wait(
      stops.asMap().entries.map((entry) async {
        final index = entry.key;
        final stop = entry.value;

        await execute<DriverFetchingModel>(
          () => _fetchDriverInfo(driverId: stop.driverId),
          onSuccess: (data) {
            final driver = data!.driverTable.drivers[0];
            resolved[index] = stop.copyWith(driverId: '${driver.givenName} ${driver.familyName}');
          },
          onError: (error) => resolveError ??= error,
        );
      }),
    );

    if (resolveError != null) {
      pitStops = pitStops.toErrorFrom(resolveError!);
    } else {
      pitStops = pitStops.toValue(resolved);
    }
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

  Future<DriverFetchingModel> _fetchDriverInfo({required String driverId}) {
    final override = _fetchDriverInfoOverride;
    return fetchFromLoader(
      override: override == null ? null : () => override(driverId: driverId),
      load: () => DriverLoader.loadData(driverId: driverId),
      parse: DriverFetchingModel.fromJson,
      withCache: checkCache,
    );
  }
}
