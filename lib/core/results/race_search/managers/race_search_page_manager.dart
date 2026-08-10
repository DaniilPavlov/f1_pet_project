import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/scroll_controller_extension.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/core/results/race_search/state/state_holders/race_search_page_state_holder.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/l10n/app_localizations_ru.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter/material.dart';

/// Управляет полями поиска и загрузкой результатов гонки.
class RaceSearchPageManager {
  RaceSearchPageManager({
    required this.languageCode,
    required RaceSearchPageStateHolder holder,
    RaceWeekendRepository? raceWeekendRepository,
    AnalyticsGateway? analytics,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResultsForTest,
  }) : _holder = holder,
       _raceWeekendRepository = raceWeekendRepository,
       _analytics = analytics,
       _fetchRaceResultsForTest = fetchRaceResultsForTest;

  final String languageCode;
  final RaceSearchPageStateHolder _holder;
  final RaceWeekendRepository? _raceWeekendRepository;
  final AnalyticsGateway? _analytics;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResultsForTest;

  /// Ввод года сезона.
  final yearController = TextEditingController();
  /// Отображение выбранной гонки (только для показа).
  final raceDisplayController = TextEditingController();
  /// Ввод номера раунда.
  final roundController = TextEditingController();
  /// Управление прокруткой результатов гонки.
  final scrollController = ScrollController();

  var _disposed = false;

  /// Локализация (русский или английский).
  AppLocalizations get l10n => languageCode == 'ru' ? AppLocalizationsRu() : AppLocalizationsEn();

  /// Проверяет заполненность сезона и гонки.
  void checkFields() {
    _holder.setViewModel(
      _holder.viewModel.copyWith(fieldsInputted: yearController.isValidYear && roundController.isValidRound),
    );
  }

  /// Смена сезона сбрасывает выбранную гонку.
  void onSeasonSelected() {
    raceDisplayController.clear();
    roundController.clear();
    _holder.setViewModel(_holder.viewModel.copyWith(selectedSeason: yearController.text));
    checkFields();
  }

  /// Выбор гонки из списка сезона.
  void onRacePicked(RacePick pick) {
    roundController.text = pick.round;
    checkFields();
  }

  /// Загружает результаты гонки по выбранным сезону и раунду.
  Future<void> loadRaceResults() async {
    _holder.setViewModel(_holder.viewModel.copyWith(dataIsLoaded: false));
    FocusManager.instance.primaryFocus?.unfocus();

    await runAsyncLoad<ScheduleModel, RacesModel?>(
      fetch: () => _fetchRaceResults(year: yearController.text, round: roundController.text),
      getField: () => _holder.viewModel.searchedRace,
      setField: (value) {
        if (_disposed) {
          return;
        }
        _holder.setViewModel(_holder.viewModel.copyWith(searchedRace: value));
      },
      onSuccess: (data) {
        if (_disposed) {
          return;
        }
        if (data!.raceTable.races.isNotEmpty) {
          _holder.setViewModel(
            _holder.viewModel.copyWith(
              errorMessage: '',
              searchedRace: _holder.viewModel.searchedRace.toValue(data.raceTable.races[0]),
            ),
          );
          _analytics?.log(RaceSearched(query: '${yearController.text} R${roundController.text}'));
          Future<void>.delayed(const Duration(milliseconds: 100), scrollController.animateToBottom);
        } else {
          _holder.setViewModel(
            _holder.viewModel.copyWith(
              searchedRace: const Loadable.value(),
              errorMessage: l10n.raceNotFound,
            ),
          );
        }
      },
    );

    if (_disposed) {
      return;
    }

    final current = _holder.viewModel;
    if (current.searchedRace.isError) {
      _holder.setViewModel(
        current.copyWith(
          errorMessage: current.searchedRace.exception?.title ?? current.searchedRace.error!.errorMessage,
        ),
      );
    }

    _holder.setViewModel(_holder.viewModel.copyWith(dataIsLoaded: true));
  }

  /// Очищает ресурсы менеджера.
  void dispose() {
    _disposed = true;
    yearController.dispose();
    raceDisplayController.dispose();
    roundController.dispose();
    scrollController.dispose();
  }

  Future<ScheduleModel> _fetchRaceResults({required String year, required String round}) {
    final forTest = _fetchRaceResultsForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository!.raceResults(year: year, round: round);
  }
}
