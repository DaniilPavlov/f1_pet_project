import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/common/utils/helpers/scroll_controller_extension.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/l10n/app_localizations_ru.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Состояние экрана поиска гонки.
@immutable
class RaceSearchState {
  const RaceSearchState({
    this.searchedRace = const Loadable.value(),
    this.dataIsLoaded = true,
    this.fieldsInputted = false,
    this.errorMessage = '',
    this.selectedSeason = '',
  });

  final Loadable<RacesModel?> searchedRace;
  final bool dataIsLoaded;
  final bool fieldsInputted;
  final String errorMessage;
  final String selectedSeason;

  RaceSearchState copyWith({
    Loadable<RacesModel?>? searchedRace,
    bool? dataIsLoaded,
    bool? fieldsInputted,
    String? errorMessage,
    String? selectedSeason,
  }) {
    return RaceSearchState(
      searchedRace: searchedRace ?? this.searchedRace,
      dataIsLoaded: dataIsLoaded ?? this.dataIsLoaded,
      fieldsInputted: fieldsInputted ?? this.fieldsInputted,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedSeason: selectedSeason ?? this.selectedSeason,
    );
  }
}

/// Управляет полями поиска и загрузкой результатов гонки.
class RaceSearchScreenController extends Notifier<RaceSearchState> {
  RaceSearchScreenController(
    this.languageCode, {
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResultsForTest,
    @visibleForTesting AnalyticsGateway? analyticsForTest,
  }) : _fetchRaceResultsForTest = fetchRaceResultsForTest,
       _analyticsForTest = analyticsForTest;

  final String languageCode;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResultsForTest;
  final AnalyticsGateway? _analyticsForTest;

  late final TextEditingController yearController;
  late final TextEditingController raceDisplayController;
  late final TextEditingController roundController;
  late final ScrollController scrollController;

  AppLocalizations get l10n => languageCode == 'ru' ? AppLocalizationsRu() : AppLocalizationsEn();

  RaceWeekendRepository get _raceWeekendRepository => ref.read(raceWeekendRepositoryProvider);

  AnalyticsGateway get _analytics => _analyticsForTest ?? ref.read(analyticsGatewayProvider);

  @override
  RaceSearchState build() {
    yearController = TextEditingController();
    raceDisplayController = TextEditingController();
    roundController = TextEditingController();
    scrollController = ScrollController();
    ref.onDispose(() {
      yearController.dispose();
      raceDisplayController.dispose();
      roundController.dispose();
      scrollController.dispose();
    });
    return const RaceSearchState();
  }

  /// Проверяет заполненность сезона и гонки.
  void checkFields() {
    state = state.copyWith(fieldsInputted: yearController.isValidYear && roundController.isValidRound);
  }

  /// Смена сезона сбрасывает выбранную гонку.
  void onSeasonSelected() {
    raceDisplayController.clear();
    roundController.clear();
    state = state.copyWith(selectedSeason: yearController.text);
    checkFields();
  }

  /// Выбор гонки из списка сезона.
  void onRacePicked(RacePick pick) {
    roundController.text = pick.round;
    checkFields();
  }

  /// Ищет гонку по выбранным сезону и раунду.
  Future<void> loadRaceResults() async {
    state = state.copyWith(dataIsLoaded: false);
    FocusManager.instance.primaryFocus?.unfocus();

    await runAsyncLoad<ScheduleModel, RacesModel?>(
      fetch: () => _fetchRaceResults(year: yearController.text, round: roundController.text),
      getField: () => state.searchedRace,
      setField: (value) => state = state.copyWith(searchedRace: value),
      onSuccess: (data) {
        if (data!.raceTable.races.isNotEmpty) {
          state = state.copyWith(
            errorMessage: '',
            searchedRace: state.searchedRace.toValue(data.raceTable.races[0]),
          );
          _analytics.log(RaceSearched(query: '${yearController.text} R${roundController.text}'));
          Future<void>.delayed(const Duration(milliseconds: 100), scrollController.animateToBottom);
        } else {
          state = state.copyWith(
            searchedRace: const Loadable.value(),
            errorMessage: l10n.raceNotFound,
          );
        }
      },
    );

    if (!ref.mounted) {
      return;
    }

    if (state.searchedRace.isError) {
      state = state.copyWith(
        errorMessage: state.searchedRace.exception?.title ?? state.searchedRace.error!.errorMessage,
      );
    }

    state = state.copyWith(dataIsLoaded: true);
  }

  Future<ScheduleModel> _fetchRaceResults({required String year, required String round}) {
    final forTest = _fetchRaceResultsForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository.raceResults(year: year, round: round);
  }
}

final raceSearchScreenControllerProvider =
    NotifierProvider.autoDispose.family<RaceSearchScreenController, RaceSearchState, String>(
      RaceSearchScreenController.new,
    );
