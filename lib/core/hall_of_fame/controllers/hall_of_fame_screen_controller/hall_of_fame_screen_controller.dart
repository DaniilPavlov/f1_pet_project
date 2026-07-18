import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/fetch_from_loader.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/helpers/text_editing_controller_extension.dart';
import 'package:f1_pet_project/core/hall_of_fame/loaders/constructors_standings_loader.dart';
import 'package:f1_pet_project/core/hall_of_fame/loaders/drivers_standings_loader.dart';
import 'package:f1_pet_project/core/home/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/core/home/models/standings/standings_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'hall_of_fame_screen_controller.g.dart';

/// MobX-контроллер экрана «Зал славы».
class HallOfFameScreenController = HallOfFameScreenControllerBase with _$HallOfFameScreenController;

/// Управляет зачётами пилотов/конструкторов за выбранный сезон.
abstract class HallOfFameScreenControllerBase with Store {
  HallOfFameScreenControllerBase({
    Future<StandingsModel> Function(String year)? fetchDriversStandings,
    Future<StandingsModel> Function(String year)? fetchConstructorsStandings,
  }) : _fetchDriversStandingsOverride = fetchDriversStandings,
       _fetchConstructorsStandingsOverride = fetchConstructorsStandings {
    yearController = TextEditingController(text: '2026');
  }

  final Future<StandingsModel> Function(String year)? _fetchDriversStandingsOverride;
  final Future<StandingsModel> Function(String year)? _fetchConstructorsStandingsOverride;

  late final TextEditingController yearController;

  @observable
  AsyncValue<List<StandingsListsModel>> driversStandings = const AsyncValue.loading();

  @observable
  AsyncValue<List<StandingsListsModel>> constructorsStandings = const AsyncValue.loading();

  @observable
  bool fieldsInputted = true;

  @computed
  CustomException? get screenError => firstException([driversStandings, constructorsStandings]);

  /// Освобождает контроллер поля сезона.
  void dispose() {
    yearController.dispose();
  }

  /// Проверяет корректность введённого года сезона.
  @action
  void checkFields() {
    fieldsInputted = yearController.isValidYear;
  }

  /// Загружает зачёты пилотов и конструкторов за выбранный сезон.
  @action
  Future<void> loadAllData() async {
    final year = yearController.text;
    await Future.wait([loadConstructorsStandings(year: year), loadDriversStandings(year: year)]);
  }

  /// Загружает зачёт пилотов за указанный сезон.
  @action
  Future<void> loadDriversStandings({required String year}) async {
    await runAsyncLoad<StandingsModel, List<StandingsListsModel>>(
      fetch: () => _fetchDriversStandings(year: year),
      getField: () => driversStandings,
      setField: (value) => driversStandings = value,
      onSuccess: (data) => driversStandings = driversStandings.toValue(data!.standingsTable.standingsLists),
    );
  }

  /// Загружает зачёт конструкторов за указанный сезон.
  @action
  Future<void> loadConstructorsStandings({required String year}) async {
    await runAsyncLoad<StandingsModel, List<StandingsListsModel>>(
      fetch: () => _fetchConstructorsStandings(year: year),
      getField: () => constructorsStandings,
      setField: (value) => constructorsStandings = value,
      onSuccess: (data) => constructorsStandings = constructorsStandings.toValue(data!.standingsTable.standingsLists),
    );
  }

  Future<StandingsModel> _fetchDriversStandings({required String year}) {
    final override = _fetchDriversStandingsOverride;
    return fetchFromLoader(
      override: override == null ? null : () => override(year),
      load: () => DriversStandingsLoader.loadData(year: year),
      parse: StandingsModel.fromJson,
    );
  }

  Future<StandingsModel> _fetchConstructorsStandings({required String year}) {
    final override = _fetchConstructorsStandingsOverride;
    return fetchFromLoader(
      override: override == null ? null : () => override(year),
      load: () => ConstructorsStandingsLoader.loadData(year: year),
      parse: StandingsModel.fromJson,
    );
  }
}
