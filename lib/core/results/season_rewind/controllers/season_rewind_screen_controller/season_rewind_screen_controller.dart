import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
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
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:f1_pet_project/services/executor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние экрана «Перемотка сезона».
@immutable
class SeasonRewindState {
  const SeasonRewindState({
    this.races = const Loadable.loading(),
    this.driversStandings = const Loadable.loading(),
    this.constructorsStandings = const Loadable.loading(),
    this.selectedRoundIndex = 0,
    this.isPlaying = false,
    this.chartDrivers = const [],
    this.chartConstructors = const [],
    this.chartRound,
    this.chartLoading = false,
  });

  final Loadable<List<RacesModel>> races;
  final Loadable<List<StandingsListsModel>> driversStandings;
  final Loadable<List<StandingsListsModel>> constructorsStandings;
  final int selectedRoundIndex;
  final bool isPlaying;

  /// Последние standings, совпадающие с ответом API (не stale при loading).
  final List<DriverStandingsModel> chartDrivers;
  final List<ConstructorStandingsModel> chartConstructors;

  /// Раунд, к которому относятся [chartDrivers] / [chartConstructors].
  final String? chartRound;
  final bool chartLoading;

  CustomException? get screenError => firstException([races, driversStandings, constructorsStandings]);

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

  bool get canPlay {
    final list = races.value;
    return list != null && list.length > 1;
  }

  bool get hasChartData => chartDrivers.isNotEmpty && chartConstructors.isNotEmpty;

  /// Очки на экране не от [selectedRace] — не показываем chart, пока не догрузим.
  bool get isChartStale {
    final race = selectedRace;
    if (race == null || chartRound == null) {
      return true;
    }
    return chartRound != race.round;
  }

  SeasonRewindState copyWith({
    Loadable<List<RacesModel>>? races,
    Loadable<List<StandingsListsModel>>? driversStandings,
    Loadable<List<StandingsListsModel>>? constructorsStandings,
    int? selectedRoundIndex,
    bool? isPlaying,
    List<DriverStandingsModel>? chartDrivers,
    List<ConstructorStandingsModel>? chartConstructors,
    String? chartRound,
    bool clearChartRound = false,
    bool? chartLoading,
  }) {
    return SeasonRewindState(
      races: races ?? this.races,
      driversStandings: driversStandings ?? this.driversStandings,
      constructorsStandings: constructorsStandings ?? this.constructorsStandings,
      selectedRoundIndex: selectedRoundIndex ?? this.selectedRoundIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      chartDrivers: chartDrivers ?? this.chartDrivers,
      chartConstructors: chartConstructors ?? this.chartConstructors,
      chartRound: clearChartRound ? null : (chartRound ?? this.chartRound),
      chartLoading: chartLoading ?? this.chartLoading,
    );
  }
}

/// Управляет списком раундов и standings после выбранного этапа.
class SeasonRewindScreenController extends Notifier<SeasonRewindState> {
  SeasonRewindScreenController({
    @visibleForTesting SeasonsRepository? seasonsRepositoryForTest,
    @visibleForTesting
    Future<StandingsModel> Function(String year, String round)? fetchDriversStandingsForTest,
    @visibleForTesting
    Future<StandingsModel> Function(String year, String round)? fetchConstructorsStandingsForTest,
    @visibleForTesting Future<List<RacesModel>> Function(String year)? fetchSeasonRacesForTest,
    @visibleForTesting AppDataRefresh? dataRefreshForTest,
    @visibleForTesting Duration playInterval = const Duration(milliseconds: 1500),
  }) : _seasonsRepositoryForTest = seasonsRepositoryForTest,
       _fetchDriversStandingsForTest = fetchDriversStandingsForTest,
       _fetchConstructorsStandingsForTest = fetchConstructorsStandingsForTest,
       _fetchSeasonRacesForTest = fetchSeasonRacesForTest,
       _dataRefreshForTest = dataRefreshForTest,
       _playInterval = playInterval;

  final SeasonsRepository? _seasonsRepositoryForTest;
  final Future<StandingsModel> Function(String year, String round)? _fetchDriversStandingsForTest;
  final Future<StandingsModel> Function(String year, String round)? _fetchConstructorsStandingsForTest;
  final Future<List<RacesModel>> Function(String year)? _fetchSeasonRacesForTest;
  final AppDataRefresh? _dataRefreshForTest;
  final Duration _playInterval;

  late final TextEditingController yearController;

  Timer? _playTimer;
  int _standingsRequestId = 0;

  bool get _usingTestFetches =>
      _fetchDriversStandingsForTest != null ||
      _fetchConstructorsStandingsForTest != null ||
      _fetchSeasonRacesForTest != null;

  SeasonStandingsRepository get _standingsRepository => ref.read(seasonStandingsRepositoryProvider);

  RaceWeekendRepository get _raceWeekendRepository => ref.read(raceWeekendRepositoryProvider);

  @override
  SeasonRewindState build() {
    yearController = TextEditingController(text: '2026');
    ref.onDispose(() {
      stopPlayback();
      yearController.dispose();
    });
    return const SeasonRewindState();
  }

  /// Подставляет актуальный сезон и грузит раунды + standings.
  Future<void> bootstrap() async {
    final repository = _seasonsRepositoryForTest ??
        (_usingTestFetches ? null : ref.read(seasonsRepositoryProvider));
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
  Future<void> onSeasonChanged() async {
    stopPlayback();
    await loadSeason();
  }

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка.
  Future<void> refreshAll() async {
    stopPlayback();
    if (_dataRefreshForTest != null) {
      await _dataRefreshForTest.clearAll();
    } else if (!_usingTestFetches) {
      await ref.read(appDataRefreshProvider).clearAll();
    }
    await loadSeason();
  }

  /// Загружает завершённые раунды сезона и standings для выбранного.
  Future<void> loadSeason() async {
    if (!yearController.isValidYear) {
      state = state.copyWith(races: state.races.toError('Invalid year: ${yearController.text}'));
      return;
    }

    final year = yearController.text;
    await runAsyncLoad<List<RacesModel>, List<RacesModel>>(
      fetch: () => _fetchSeasonRaces(year: year),
      getField: () => state.races,
      setField: (value) => state = state.copyWith(races: value),
      onSuccess: (data) {
        final scrubbable = completedRacesAsOf(data ?? const [], DateTime.now());
        state = state.copyWith(
          races: state.races.toValue(scrubbable),
          selectedRoundIndex: scrubbable.isEmpty ? 0 : scrubbable.length - 1,
        );
      },
    );

    if (!ref.mounted) {
      return;
    }

    if (state.races.isError || (state.races.value?.isEmpty ?? true)) {
      state = state.copyWith(
        driversStandings: const Loadable.value(value: <StandingsListsModel>[]),
        constructorsStandings: const Loadable.value(value: <StandingsListsModel>[]),
        chartDrivers: const [],
        chartConstructors: const [],
        clearChartRound: true,
      );
      return;
    }

    await loadStandingsForSelectedRound();
  }

  /// Двигает [selectedRoundIndex] без запроса standings (используется из [selectRound]).
  void previewRound(int index) {
    final list = state.races.value;
    if (list == null || list.isEmpty) {
      return;
    }
    state = state.copyWith(selectedRoundIndex: index.clamp(0, list.length - 1));
  }

  /// Фиксирует раунд и подгружает standings (onChangeEnd / play).
  Future<void> selectRound(int index) async {
    previewRound(index);
    await loadStandingsForSelectedRound();
  }

  /// Загружает standings после [selectedRace].
  Future<void> loadStandingsForSelectedRound() async {
    final race = state.selectedRace;
    if (race == null) {
      return;
    }

    final requestId = ++_standingsRequestId;
    final year = race.season;
    final round = race.round;

    state = state.copyWith(
      chartLoading: true,
      driversStandings: state.driversStandings.toLoading(),
      constructorsStandings: state.constructorsStandings.toLoading(),
    );

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

      if (requestId != _standingsRequestId || !ref.mounted) {
        return;
      }

      await execute<StandingsModel>(
        () => _fetchConstructorsStandings(year: year, round: round),
        maxAttempts: 3,
        onSuccess: (data) => constructorsModel = data,
        onError: (error) => constructorsError = error,
      );

      if (requestId != _standingsRequestId || !ref.mounted) {
        return;
      }

      if (driversModel == null || constructorsModel == null) {
        final exception = driversError ?? constructorsError ?? _unexpectedStandingsError();
        state = state.copyWith(
          driversStandings: state.driversStandings.toErrorFrom(exception),
          constructorsStandings: state.constructorsStandings.toErrorFrom(exception),
        );
        return;
      }

      final driversLists = driversModel!.standingsTable.standingsLists;
      final constructorsLists = constructorsModel!.standingsTable.standingsLists;
      state = state.copyWith(
        driversStandings: state.driversStandings.toValue(driversLists),
        constructorsStandings: state.constructorsStandings.toValue(constructorsLists),
      );

      final drivers = driversLists.isEmpty ? null : driversLists.first.driverStandings;
      final constructors = constructorsLists.isEmpty ? null : constructorsLists.first.constructorStandings;
      if (drivers == null || constructors == null) {
        final exception = CustomException(
          title: ErrorCopy.responseParseError,
          subtitle: ErrorCopy.errorRetrySubtitle,
        );
        state = state.copyWith(
          driversStandings: state.driversStandings.toErrorFrom(exception),
          constructorsStandings: state.constructorsStandings.toErrorFrom(exception),
        );
        return;
      }

      state = state.copyWith(
        chartDrivers: drivers,
        chartConstructors: constructors,
        chartRound: round,
      );
    } on ResponseParseException catch (error, stackTrace) {
      if (requestId != _standingsRequestId || !ref.mounted) {
        return;
      }
      final exception = CustomException(
        title: ErrorCopy.responseParseError,
        subtitle: ErrorCopy.errorRetrySubtitle,
        parentException: error,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        driversStandings: state.driversStandings.toErrorFrom(exception),
        constructorsStandings: state.constructorsStandings.toErrorFrom(exception),
      );
    } on DioException catch (error, stackTrace) {
      if (requestId != _standingsRequestId || !ref.mounted) {
        return;
      }
      final exception = _dioToException(error, stackTrace);
      state = state.copyWith(
        driversStandings: state.driversStandings.toErrorFrom(exception),
        constructorsStandings: state.constructorsStandings.toErrorFrom(exception),
      );
    } on Object catch (error, stackTrace) {
      if (requestId != _standingsRequestId || !ref.mounted) {
        return;
      }
      final exception = CustomException(
        title: ErrorCopy.unexpectedError,
        subtitle: ErrorCopy.errorRetrySubtitle,
        parentException: error is Exception ? error : null,
        stackTrace: stackTrace,
      );
      state = state.copyWith(
        driversStandings: state.driversStandings.toErrorFrom(exception),
        constructorsStandings: state.constructorsStandings.toErrorFrom(exception),
      );
    } finally {
      if (requestId == _standingsRequestId && ref.mounted) {
        state = state.copyWith(chartLoading: false);
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
  void togglePlayback() {
    if (state.isPlaying) {
      stopPlayback();
    } else {
      startPlayback();
    }
  }

  /// Автопрокрутка от текущего раунда к финалу (или с начала, если уже в конце).
  void startPlayback() {
    final list = state.races.value;
    if (list == null || list.length < 2) {
      return;
    }

    stopPlayback();
    if (state.selectedRoundIndex >= list.length - 1) {
      state = state.copyWith(selectedRoundIndex: 0);
      unawaited(loadStandingsForSelectedRound());
    }

    state = state.copyWith(isPlaying: true);
    _playTimer = Timer.periodic(_playInterval, (_) {
      final racesList = state.races.value;
      if (racesList == null || racesList.isEmpty) {
        stopPlayback();
        return;
      }
      if (state.selectedRoundIndex >= racesList.length - 1) {
        stopPlayback();
        return;
      }
      unawaited(selectRound(state.selectedRoundIndex + 1));
    });
  }

  /// Останавливает автопрокрутку.
  void stopPlayback() {
    _playTimer?.cancel();
    _playTimer = null;
    if (ref.mounted) {
      state = state.copyWith(isPlaying: false);
    }
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
    return _raceWeekendRepository.seasonRaces(year: year);
  }

  Future<StandingsModel> _fetchDriversStandings({required String year, required String round}) {
    final forTest = _fetchDriversStandingsForTest;
    if (forTest != null) {
      return forTest(year, round);
    }
    return _standingsRepository.drivers(year: year, round: round);
  }

  Future<StandingsModel> _fetchConstructorsStandings({required String year, required String round}) {
    final forTest = _fetchConstructorsStandingsForTest;
    if (forTest != null) {
      return forTest(year, round);
    }
    return _standingsRepository.constructors(year: year, round: round);
  }
}

final seasonRewindScreenControllerProvider =
    NotifierProvider.autoDispose<SeasonRewindScreenController, SeasonRewindState>(
      SeasonRewindScreenController.new,
    );
