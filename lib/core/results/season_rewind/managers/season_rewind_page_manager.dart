import 'dart:async';

import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/localization/error_copy.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/repositories/season_standings_repository.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/results/season_rewind/state/state_holders/season_rewind_page_state_holder.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/executor.dart';
import 'package:flutter/material.dart';

/// Управляет списком раундов и standings после выбранного этапа.
class SeasonRewindPageManager {
  SeasonRewindPageManager({
    required SeasonRewindPageStateHolder holder,
    SeasonsRepository? seasonsRepository,
    SeasonStandingsRepository? standingsRepository,
    RaceWeekendRepository? raceWeekendRepository,
    AppDataRefresh? dataRefresh,
    @visibleForTesting Future<StandingsModel> Function(String year, String round)? fetchDriversStandingsForTest,
    @visibleForTesting Future<StandingsModel> Function(String year, String round)? fetchConstructorsStandingsForTest,
    @visibleForTesting Future<List<RacesModel>> Function(String year)? fetchSeasonRacesForTest,
    @visibleForTesting Duration playInterval = const Duration(milliseconds: 1500),
  }) : _holder = holder,
       _seasonsRepository = seasonsRepository,
       _standingsRepository = standingsRepository,
       _raceWeekendRepository = raceWeekendRepository,
       _dataRefresh = dataRefresh,
       _fetchDriversStandingsForTest = fetchDriversStandingsForTest,
       _fetchConstructorsStandingsForTest = fetchConstructorsStandingsForTest,
       _fetchSeasonRacesForTest = fetchSeasonRacesForTest,
       _playInterval = playInterval;

  final SeasonRewindPageStateHolder _holder;
  final SeasonsRepository? _seasonsRepository;
  final SeasonStandingsRepository? _standingsRepository;
  final RaceWeekendRepository? _raceWeekendRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<StandingsModel> Function(String year, String round)? _fetchDriversStandingsForTest;
  final Future<StandingsModel> Function(String year, String round)? _fetchConstructorsStandingsForTest;
  final Future<List<RacesModel>> Function(String year)? _fetchSeasonRacesForTest;
  final Duration _playInterval;

  /// Ввод года для фильтра.
  final yearController = TextEditingController(text: '2026');

  Timer? _playTimer;
  int _standingsRequestId = 0;
  var _disposed = false;

  /// Подставляет актуальный сезон и грузит раунды + standings.
  Future<void> bootstrap() async {
    final repository = _seasonsRepository;
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
    if (_disposed) {
      return;
    }
    await loadSeason();
  }

  /// Перезагружает сезон после смены года в пикере.
  Future<void> onSeasonChanged() async {
    stopPlayback();
    await loadSeason();
  }

  Future<void> refreshAll() async {
    stopPlayback();
    await _dataRefresh?.clearAll();
    if (_disposed) {
      return;
    }
    await loadSeason();
  }

  /// Загружает завершённые раунды сезона и standings для выбранного.
  Future<void> loadSeason() async {
    if (!yearController.isValidYear) {
      _holder.setViewModel(
        _holder.viewModel.copyWith(races: _holder.viewModel.races.toError('Invalid year: ${yearController.text}')),
      );
      return;
    }

    final year = yearController.text;
    await runAsyncLoad<List<RacesModel>, List<RacesModel>>(
      fetch: () => _fetchSeasonRaces(year: year),
      getField: () => _holder.viewModel.races,
      setField: (value) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(_holder.viewModel.copyWith(races: value));
      },
      onSuccess: (data) {
        if (_disposed) {
          return;
        }
        final scrubbable = completedRacesAsOf(data ?? const [], DateTime.now());
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            races: _holder.viewModel.races.toValue(scrubbable),
            selectedRoundIndex: scrubbable.isEmpty ? 0 : scrubbable.length - 1,
          ),
        );
      },
    );

    if (_disposed) {
      return;
    }

    if (_holder.viewModel.races.isError || (_holder.viewModel.races.value?.isEmpty ?? true)) {
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          driversStandings: const Loadable.value(value: <StandingsListsModel>[]),
          constructorsStandings: const Loadable.value(value: <StandingsListsModel>[]),
          chartDrivers: const [],
          chartConstructors: const [],
          chartRound: null,
        ),
      );
      return;
    }

    await loadStandingsForSelectedRound();
  }

  /// Двигает [selectedRoundIndex] без запроса standings (используется из [selectRound]).
  void previewRound(int index) {
    final list = _holder.viewModel.races.value;
    if (list == null || list.isEmpty) {
      return;
    }
    _holder.setViewModel(_holder.viewModel.copyWith(selectedRoundIndex: index.clamp(0, list.length - 1)));
  }

  /// Фиксирует раунд и подгружает standings (onChangeEnd / play).
  Future<void> selectRound(int index) async {
    previewRound(index);
    await loadStandingsForSelectedRound();
  }

  /// Загружает standings после [selectedRace].
  Future<void> loadStandingsForSelectedRound() async {
    final race = _holder.viewModel.selectedRace;
    if (race == null) {
      return;
    }

    final requestId = ++_standingsRequestId;
    final year = race.season;
    final round = race.round;

    _holder.setViewModel(
      _holder.viewModel.copyWith(
        chartLoading: true,
        driversStandings: _holder.viewModel.driversStandings.toLoading(),
        constructorsStandings: _holder.viewModel.constructorsStandings.toLoading(),
      ),
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

      if (requestId != _standingsRequestId || _disposed) {
        return;
      }

      await execute<StandingsModel>(
        () => _fetchConstructorsStandings(year: year, round: round),
        maxAttempts: 3,
        onSuccess: (data) => constructorsModel = data,
        onError: (error) => constructorsError = error,
      );

      if (requestId != _standingsRequestId || _disposed) {
        return;
      }

      if (driversModel == null || constructorsModel == null) {
        final exception = driversError ?? constructorsError ?? _unexpectedStandingsError();
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            driversStandings: _holder.viewModel.driversStandings.toErrorFrom(exception),
            constructorsStandings: _holder.viewModel.constructorsStandings.toErrorFrom(exception),
          ),
        );
        return;
      }

      final driversLists = driversModel!.standingsTable.standingsLists;
      final constructorsLists = constructorsModel!.standingsTable.standingsLists;
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          driversStandings: _holder.viewModel.driversStandings.toValue(driversLists),
          constructorsStandings: _holder.viewModel.constructorsStandings.toValue(constructorsLists),
        ),
      );

      final drivers = driversLists.isEmpty ? null : driversLists.first.driverStandings;
      final constructors = constructorsLists.isEmpty ? null : constructorsLists.first.constructorStandings;
      if (drivers == null || constructors == null) {
        final exception = CustomException(
          title: ErrorCopy.responseParseError,
          subtitle: ErrorCopy.errorRetrySubtitle,
        );
        _holder.setViewModel(
          _holder.viewModel.copyWith(
            driversStandings: _holder.viewModel.driversStandings.toErrorFrom(exception),
            constructorsStandings: _holder.viewModel.constructorsStandings.toErrorFrom(exception),
          ),
        );
        return;
      }

      _holder.setViewModel(
        _holder.viewModel.copyWith(
          chartDrivers: drivers,
          chartConstructors: constructors,
          chartRound: round,
        ),
      );
    } on ResponseParseException catch (error, stackTrace) {
      if (requestId != _standingsRequestId || _disposed) {
        return;
      }
      final exception = CustomException(
        title: ErrorCopy.responseParseError,
        subtitle: ErrorCopy.errorRetrySubtitle,
        parentException: error,
        stackTrace: stackTrace,
      );
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          driversStandings: _holder.viewModel.driversStandings.toErrorFrom(exception),
          constructorsStandings: _holder.viewModel.constructorsStandings.toErrorFrom(exception),
        ),
      );
    } on DioException catch (error, stackTrace) {
      if (requestId != _standingsRequestId || _disposed) {
        return;
      }
      final exception = _dioToException(error, stackTrace);
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          driversStandings: _holder.viewModel.driversStandings.toErrorFrom(exception),
          constructorsStandings: _holder.viewModel.constructorsStandings.toErrorFrom(exception),
        ),
      );
    } on Object catch (error, stackTrace) {
      if (requestId != _standingsRequestId || _disposed) {
        return;
      }
      final exception = CustomException(
        title: ErrorCopy.unexpectedError,
        subtitle: ErrorCopy.errorRetrySubtitle,
        parentException: error is Exception ? error : null,
        stackTrace: stackTrace,
      );
      _holder.setViewModel(
        _holder.viewModel.copyWith(
          driversStandings: _holder.viewModel.driversStandings.toErrorFrom(exception),
          constructorsStandings: _holder.viewModel.constructorsStandings.toErrorFrom(exception),
        ),
      );
    } finally {
      if (requestId == _standingsRequestId && !_disposed) {
        _holder.setViewModel(_holder.viewModel.copyWith(chartLoading: false));
      }
    }
  }

  /// Запускает или ставит на паузу автопрокрутку раундов.
  void togglePlayback() {
    if (_holder.viewModel.isPlaying) {
      stopPlayback();
    } else {
      startPlayback();
    }
  }

  /// Автопрокрутка от текущего раунда к финалу (или с начала, если уже в конце).
  void startPlayback() {
    final list = _holder.viewModel.races.value;
    if (list == null || list.length < 2) {
      return;
    }

    stopPlayback();
    if (_holder.viewModel.selectedRoundIndex >= list.length - 1) {
      _holder.setViewModel(_holder.viewModel.copyWith(selectedRoundIndex: 0));
      unawaited(loadStandingsForSelectedRound());
    }

    _holder.setViewModel(_holder.viewModel.copyWith(isPlaying: true));
    _playTimer = Timer.periodic(_playInterval, (_) {
      final racesList = _holder.viewModel.races.value;
      if (racesList == null || racesList.isEmpty) {
        stopPlayback();
        return;
      }
      if (_holder.viewModel.selectedRoundIndex >= racesList.length - 1) {
        stopPlayback();
        return;
      }
      unawaited(selectRound(_holder.viewModel.selectedRoundIndex + 1));
    });
  }

  /// Останавливает автопрокрутку.
  void stopPlayback() {
    _playTimer?.cancel();
    _playTimer = null;
    if (!_disposed) {
      _holder.setViewModel(_holder.viewModel.copyWith(isPlaying: false));
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

  /// Очищает ресурсы менеджера и останавливает автопрокрутку.
  void dispose() {
    _playTimer?.cancel();
    _playTimer = null;
    _disposed = true;
    yearController.dispose();
  }

  static CustomException _unexpectedStandingsError() => CustomException(
        title: ErrorCopy.unexpectedError,
        subtitle: ErrorCopy.errorRetrySubtitle,
      );

  static CustomException _dioToException(DioException error, StackTrace stackTrace) {
    final status = error.response?.statusCode;
    final isConnectionIssue = error.type == DioExceptionType.connectionError ||
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
