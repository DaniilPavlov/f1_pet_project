import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/repositories/season_standings_repository.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/executor.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'season_rewind_screen_controller.g.dart';

/// MobX-контроллер экрана «Перемотка сезона».
class SeasonRewindScreenController = SeasonRewindScreenControllerBase with _$SeasonRewindScreenController;

/// Управляет списком раундов и standings после выбранного этапа.
abstract class SeasonRewindScreenControllerBase with Store {
  SeasonRewindScreenControllerBase({
    this.seasonsRepository,
    SeasonStandingsRepository? standingsRepository,
    RaceWeekendRepository? raceWeekendRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting
    Future<StandingsModel> Function(String year, String round)? fetchDriversStandingsForTest,
    @visibleForTesting
    Future<StandingsModel> Function(String year, String round)? fetchConstructorsStandingsForTest,
    @visibleForTesting Future<List<RacesModel>> Function(String year)? fetchSeasonRacesForTest,
    @visibleForTesting Duration playInterval = const Duration(milliseconds: 1500),
  }) : _standingsRepository = standingsRepository,
       _raceWeekendRepository = raceWeekendRepository,
       _dataRefresh = dataRefresh,
       _fetchDriversStandingsForTest = fetchDriversStandingsForTest,
       _fetchConstructorsStandingsForTest = fetchConstructorsStandingsForTest,
       _fetchSeasonRacesForTest = fetchSeasonRacesForTest,
       _playInterval = playInterval {
    yearController = TextEditingController(text: '2026');
  }

  final SeasonsRepository? seasonsRepository;
  final SeasonStandingsRepository? _standingsRepository;
  final RaceWeekendRepository? _raceWeekendRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<StandingsModel> Function(String year, String round)? _fetchDriversStandingsForTest;
  final Future<StandingsModel> Function(String year, String round)? _fetchConstructorsStandingsForTest;
  final Future<List<RacesModel>> Function(String year)? _fetchSeasonRacesForTest;
  final Duration _playInterval;

  late final TextEditingController yearController;

  Timer? _playTimer;
  int _standingsRequestId = 0;

  @observable
  AsyncValue<List<RacesModel>> races = const AsyncValue.loading();

  @observable
  AsyncValue<List<StandingsListsModel>> driversStandings = const AsyncValue.loading();

  @observable
  AsyncValue<List<StandingsListsModel>> constructorsStandings = const AsyncValue.loading();

  @observable
  int selectedRoundIndex = 0;

  @observable
  bool isPlaying = false;

  /// Последние standings, совпадающие с ответом API (не stale при loading).
  @observable
  List<DriverStandingsModel> chartDrivers = const [];

  @observable
  List<ConstructorStandingsModel> chartConstructors = const [];

  /// Раунд, к которому относятся [chartDrivers] / [chartConstructors].
  @observable
  String? chartRound;

  @observable
  bool chartLoading = false;

  @computed
  CustomException? get screenError => firstException([races, driversStandings, constructorsStandings]);

  @computed
  RacesModel? get selectedRace {
    final list = races.value;
    if (list == null || list.isEmpty) {
      return null;
    }
    if (selectedRoundIndex < 0 || selectedRoundIndex >= list.length) {
      return null;
    }
    return list[selectedRoundIndex];
  }

  @computed
  bool get canPlay {
    final list = races.value;
    return list != null && list.length > 1;
  }

  @computed
  bool get hasChartData => chartDrivers.isNotEmpty && chartConstructors.isNotEmpty;

  /// Очки на экране не от [selectedRace] — не показываем chart, пока не догрузим.
  @computed
  bool get isChartStale {
    final race = selectedRace;
    if (race == null || chartRound == null) {
      return true;
    }
    return chartRound != race.round;
  }

  /// Освобождает контроллер и останавливает автопроигрывание.
  void dispose() {
    stopPlayback();
    yearController.dispose();
  }

  /// Подставляет актуальный сезон и грузит раунды + standings.
  @action
  Future<void> bootstrap() async {
    final repository = seasonsRepository;
    if (repository != null) {
      try {
        final years = await repository.getSeasonYears();
        if (years.isNotEmpty) {
          yearController.text = years.first;
        }
      } on Object {
        // Оставляем fallback-год в контроллере.
      }
    }
    await loadSeason();
  }

  /// Перезагружает сезон после смены года в пикере.
  @action
  Future<void> onSeasonChanged() async {
    stopPlayback();
    await loadSeason();
  }

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка.
  @action
  Future<void> refreshAll() async {
    stopPlayback();
    await _dataRefresh?.clearAll();
    await loadSeason();
  }

  /// Загружает завершённые раунды сезона и standings для выбранного.
  @action
  Future<void> loadSeason() async {
    if (!yearController.isValidYear) {
      races = races.toError('Invalid year: ${yearController.text}');
      return;
    }

    final year = yearController.text;
    await runAsyncLoad<List<RacesModel>, List<RacesModel>>(
      fetch: () => _fetchSeasonRaces(year: year),
      getField: () => races,
      setField: (value) => races = value,
      onSuccess: (data) {
        final scrubbable = completedRacesAsOf(data ?? const [], DateTime.now());
        races = races.toValue(scrubbable);
        selectedRoundIndex = scrubbable.isEmpty ? 0 : scrubbable.length - 1;
      },
    );

    if (races.isError || (races.value?.isEmpty ?? true)) {
      driversStandings = const AsyncValue.value(value: <StandingsListsModel>[]);
      constructorsStandings = const AsyncValue.value(value: <StandingsListsModel>[]);
      chartDrivers = const [];
      chartConstructors = const [];
      chartRound = null;
      return;
    }

    await loadStandingsForSelectedRound();
  }

  /// Двигает [selectedRoundIndex] без запроса standings (используется из [selectRound]).
  @action
  void previewRound(int index) {
    final list = races.value;
    if (list == null || list.isEmpty) {
      return;
    }
    selectedRoundIndex = index.clamp(0, list.length - 1);
  }

  /// Фиксирует раунд и подгружает standings (onChangeEnd / play).
  @action
  Future<void> selectRound(int index) async {
    previewRound(index);
    await loadStandingsForSelectedRound();
  }

  /// Загружает standings после [selectedRace].
  @action
  Future<void> loadStandingsForSelectedRound() async {
    final race = selectedRace;
    if (race == null) {
      return;
    }

    final requestId = ++_standingsRequestId;
    final year = race.season;
    final round = race.round;

    chartLoading = true;
    driversStandings = driversStandings.toLoading();
    constructorsStandings = constructorsStandings.toLoading();

    try {
      StandingsModel? driversModel;
      StandingsModel? constructorsModel;
      CustomException? driversError;
      CustomException? constructorsError;

      // Последовательно + retry: Jolpica легко отдаёт 429 на параллельный scrub.
      await execute<StandingsModel>(
        () => _fetchDriversStandings(year: year, round: round),
        maxAttempts: 3,
        onSuccess: (data) => driversModel = data,
        onError: (error) => driversError = error,
      );

      if (requestId != _standingsRequestId) {
        return;
      }

      await execute<StandingsModel>(
        () => _fetchConstructorsStandings(year: year, round: round),
        maxAttempts: 3,
        onSuccess: (data) => constructorsModel = data,
        onError: (error) => constructorsError = error,
      );

      if (requestId != _standingsRequestId) {
        return;
      }

      if (driversModel == null || constructorsModel == null) {
        final exception = driversError ?? constructorsError ?? _unexpectedStandingsError();
        driversStandings = driversStandings.toErrorFrom(exception);
        constructorsStandings = constructorsStandings.toErrorFrom(exception);
        return;
      }

      final driversLists = driversModel!.standingsTable.standingsLists;
      final constructorsLists = constructorsModel!.standingsTable.standingsLists;
      driversStandings = driversStandings.toValue(driversLists);
      constructorsStandings = constructorsStandings.toValue(constructorsLists);

      final drivers = driversLists.isEmpty ? null : driversLists.first.driverStandings;
      final constructors = constructorsLists.isEmpty ? null : constructorsLists.first.constructorStandings;
      if (drivers == null || constructors == null) {
        final exception = CustomException(
          title: ErrorCopy.responseParseError,
          subtitle: ErrorCopy.errorRetrySubtitle,
        );
        driversStandings = driversStandings.toErrorFrom(exception);
        constructorsStandings = constructorsStandings.toErrorFrom(exception);
        return;
      }

      chartDrivers = drivers;
      chartConstructors = constructors;
      chartRound = round;
    } on ResponseParseException catch (error, stackTrace) {
      if (requestId != _standingsRequestId) {
        return;
      }
      final exception = CustomException(
        title: ErrorCopy.responseParseError,
        subtitle: ErrorCopy.errorRetrySubtitle,
        parentException: error,
        stackTrace: stackTrace,
      );
      driversStandings = driversStandings.toErrorFrom(exception);
      constructorsStandings = constructorsStandings.toErrorFrom(exception);
    } on DioException catch (error, stackTrace) {
      if (requestId != _standingsRequestId) {
        return;
      }
      final exception = _dioToException(error, stackTrace);
      driversStandings = driversStandings.toErrorFrom(exception);
      constructorsStandings = constructorsStandings.toErrorFrom(exception);
    } on Object catch (error, stackTrace) {
      if (requestId != _standingsRequestId) {
        return;
      }
      final exception = CustomException(
        title: ErrorCopy.unexpectedError,
        subtitle: ErrorCopy.errorRetrySubtitle,
        parentException: error is Exception ? error : null,
        stackTrace: stackTrace,
      );
      driversStandings = driversStandings.toErrorFrom(exception);
      constructorsStandings = constructorsStandings.toErrorFrom(exception);
    } finally {
      if (requestId == _standingsRequestId) {
        chartLoading = false;
      }
    }
  }

  static CustomException _unexpectedStandingsError() => CustomException(
    title: ErrorCopy.unexpectedError,
    subtitle: ErrorCopy.errorRetrySubtitle,
  );

  static CustomException _dioToException(DioException error, StackTrace stackTrace) {
    final status = error.response?.statusCode;
    final isConnectionIssue =
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.unknown;
    if (isConnectionIssue) {
      return CustomException(
        title: ErrorCopy.noConnection,
        subtitle: ErrorCopy.noConnectionSubtitle,
        parentException: error,
        stackTrace: stackTrace,
      );
    }
    if (status == 429) {
      return CustomException(
        title: ErrorCopy.tooManyRequests,
        subtitle: ErrorCopy.tooManyRequestsSubtitle,
        parentException: error,
        stackTrace: stackTrace,
      );
    }
    return CustomException(
      title: ErrorCopy.requestError,
      subtitle: ErrorCopy.errorRetrySubtitle,
      parentException: error,
      stackTrace: stackTrace,
    );
  }

  /// Запускает или ставит на паузу автопрокрутку раундов.
  @action
  void togglePlayback() {
    if (isPlaying) {
      stopPlayback();
    } else {
      startPlayback();
    }
  }

  /// Автопрокрутка от текущего раунда к финалу (или с начала, если уже в конце).
  @action
  void startPlayback() {
    final list = races.value;
    if (list == null || list.length < 2) {
      return;
    }

    stopPlayback();
    if (selectedRoundIndex >= list.length - 1) {
      selectedRoundIndex = 0;
      unawaited(loadStandingsForSelectedRound());
    }

    isPlaying = true;
    _playTimer = Timer.periodic(_playInterval, (_) {
      final racesList = races.value;
      if (racesList == null || racesList.isEmpty) {
        stopPlayback();
        return;
      }
      if (selectedRoundIndex >= racesList.length - 1) {
        stopPlayback();
        return;
      }
      unawaited(selectRound(selectedRoundIndex + 1));
    });
  }

  /// Останавливает автопрокрутку.
  @action
  void stopPlayback() {
    _playTimer?.cancel();
    _playTimer = null;
    isPlaying = false;
  }

  /// Раунды с датой не позже [asOf] (UTC-день).
  @visibleForTesting
  static List<RacesModel> completedRacesAsOf(List<RacesModel> races, DateTime asOf) {
    final today = DateTime.utc(asOf.toUtc().year, asOf.toUtc().month, asOf.toUtc().day);
    return races.where((race) {
      final parsed = DateTime.tryParse(race.date);
      if (parsed == null) {
        return true;
      }
      final raceDay = DateTime.utc(parsed.year, parsed.month, parsed.day);
      return !raceDay.isAfter(today);
    }).toList(growable: false);
  }

  Future<List<RacesModel>> _fetchSeasonRaces({required String year}) {
    final forTest = _fetchSeasonRacesForTest;
    if (forTest != null) {
      return forTest(year);
    }
    return _raceWeekendRepository!.seasonRaces(year: year);
  }

  Future<StandingsModel> _fetchDriversStandings({required String year, required String round}) {
    final forTest = _fetchDriversStandingsForTest;
    if (forTest != null) {
      return forTest(year, round);
    }
    return _standingsRepository!.drivers(year: year, round: round);
  }

  Future<StandingsModel> _fetchConstructorsStandings({required String year, required String round}) {
    final forTest = _fetchConstructorsStandingsForTest;
    if (forTest != null) {
      return forTest(year, round);
    }
    return _standingsRepository!.constructors(year: year, round: round);
  }
}
