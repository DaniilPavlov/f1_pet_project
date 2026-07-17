import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/fetch_from_loader.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/scroll_controller_extension.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/results/race_search/loaders/race_results_loader.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'race_search_screen_controller.g.dart';

/// MobX-контроллер экрана поиска гонки.
class RaceSearchScreenController = RaceSearchScreenControllerBase with _$RaceSearchScreenController;

/// Управляет полями поиска и загрузкой результатов гонки.
abstract class RaceSearchScreenControllerBase with Store {
  RaceSearchScreenControllerBase({
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResults,
  }) : _fetchRaceResultsOverride = fetchRaceResults {
    yearController = TextEditingController();
    roundController = TextEditingController();
  }

  final Future<ScheduleModel> Function({required String year, required String round})? _fetchRaceResultsOverride;

  late final TextEditingController yearController;
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

  /// Освобождает контроллеры ввода и прокрутки.
  void dispose() {
    yearController.dispose();
    roundController.dispose();
    scrollController.dispose();
  }

  /// Проверяет заполненность полей сезона и раунда.
  @action
  void checkFields() {
    fieldsInputted = yearController.isValidYear && roundController.text.isNotEmpty;
  }

  /// Ищет гонку по введённым сезону и раунду.
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
          errorMessage = 'По вашему запросу гонок не найдено. Проверьте введенные данные и попробуйте еще раз.';
        }
      },
    );

    if (searchedRace.isError) {
      errorMessage = searchedRace.exception?.title ?? searchedRace.error!.errorMessage;
    }

    dataIsLoaded = true;
  }

  Future<ScheduleModel> _fetchRaceResults({required String year, required String round}) {
    final override = _fetchRaceResultsOverride;
    return fetchFromLoader(
      override: override == null ? null : () => override(year: year, round: round),
      load: () => RaceResultsLoader.loadData(year: year, round: round),
      parse: ScheduleModel.fromJson,
    );
  }
}
