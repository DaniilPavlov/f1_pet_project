import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/race_search/loaders/season_races_loader.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:mobx/mobx.dart';

part 'race_picker_sheet_controller.g.dart';

/// MobX-контроллер bottom sheet выбора гонки.
class RacePickerSheetController = RacePickerSheetControllerBase with _$RacePickerSheetController;

/// Загружает этапы выбранного сезона.
abstract class RacePickerSheetControllerBase with Store {
  RacePickerSheetControllerBase({required this.seasonYear});

  final String seasonYear;

  @observable
  AsyncValue<List<RacesModel>> races = const AsyncValue.loading();

  /// Подтягивает гонки сезона.
  @action
  Future<void> load() async {
    races = races.toLoading();
    try {
      final response = await SeasonRacesLoader.loadData(year: seasonYear);
      final model = ScheduleModel.fromJson(Map<String, dynamic>.from(response.mrData as Map));
      races = races.toValue(model.raceTable.races);
    } on Object catch (error) {
      races = races.toError(error.toString());
    }
  }
}
