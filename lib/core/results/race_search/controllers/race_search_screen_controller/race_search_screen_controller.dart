import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/scroll_controller_extension.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'race_search_screen_controller.g.dart';

/// MobX-контроллер экрана поиска гонки.
class RaceSearchScreenController = RaceSearchScreenControllerBase with _$RaceSearchScreenController;

/// Управляет полями поиска и загрузкой результатов гонки.
abstract class RaceSearchScreenControllerBase with Store {
  RaceSearchScreenControllerBase({
    required this.l10n,
    RaceWeekendRepository? raceWeekendRepository,
    @visibleForTesting
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResultsForTest,
  }) : _raceWeekendRepository = raceWeekendRepository,
       _fetchRaceResultsForTest = fetchRaceResultsForTest {
    yearController = TextEditingController();
    raceDisplayController = TextEditingController();
    roundController = TextEditingController();
  }

  final AppLocalizations l10n;
  final RaceWeekendRepository? _raceWeekendRepository;
  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResultsForTest;

  late final TextEditingController yearController;
  late final TextEditingController raceDisplayController;
  late final TextEditingController roundController;
  final scrollController = ScrollController();

  @observable
  AsyncValue<RacesModel?> searchedRace = const AsyncValue.value();

  @observable
  bool dataIsLoaded = true;

  @observable
  bool fieldsInputted = false;

  @observable
  String errorMessage = '';

  @observable
  String selectedSeason = '';

  /// Освобождает контроллеры ввода и прокрутки.
  void dispose() {
    yearController.dispose();
    raceDisplayController.dispose();
    roundController.dispose();
    scrollController.dispose();
  }

  /// Проверяет заполненность сезона и гонки.
  @action
  void checkFields() {
    fieldsInputted = yearController.isValidYear && roundController.text.isNotEmpty;
  }

  /// Смена сезона сбрасывает выбранную гонку.
  @action
  void onSeasonSelected() {
    selectedSeason = yearController.text;
    raceDisplayController.clear();
    roundController.clear();
    checkFields();
  }

  /// Выбор гонки из списка сезона.
  @action
  void onRacePicked(RacePick pick) {
    roundController.text = pick.round;
    checkFields();
  }

  /// Ищет гонку по выбранным сезону и раунду.
  @action
  Future<void> loadRaceResults() async {
    dataIsLoaded = false;
    FocusManager.instance.primaryFocus?.unfocus();

    await runAsyncLoad<ScheduleModel, RacesModel?>(
      fetch: () => _fetchRaceResults(year: yearController.text, round: roundController.text),
      getField: () => searchedRace,
      setField: (value) => searchedRace = value,
      onSuccess: (data) {
        errorMessage = '';
        if (data!.raceTable.races.isNotEmpty) {
          searchedRace = searchedRace.toValue(data.raceTable.races[0]);
          Future<void>.delayed(const Duration(milliseconds: 100), scrollController.animateToBottom);
        } else {
          searchedRace = const AsyncValue.value();
          errorMessage = l10n.raceNotFound;
        }
      },
    );

    if (searchedRace.isError) {
      errorMessage = searchedRace.exception?.title ?? searchedRace.error!.errorMessage;
    }

    dataIsLoaded = true;
  }

  Future<ScheduleModel> _fetchRaceResults({required String year, required String round}) {
    final forTest = _fetchRaceResultsForTest;
    if (forTest != null) {
      return forTest(year: year, round: round);
    }
    return _raceWeekendRepository!.raceResults(year: year, round: round);
  }
}
