import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:mobx/mobx.dart';

part 'race_picker_sheet_controller.g.dart';

/// MobX-контроллер bottom sheet выбора гонки.
class RacePickerSheetController = RacePickerSheetControllerBase with _$RacePickerSheetController;

/// Загружает этапы выбранного сезона.
abstract class RacePickerSheetControllerBase with Store {
  RacePickerSheetControllerBase({
    required this.seasonYear,
    required RaceWeekendRepository raceWeekendRepository,
  }) : _raceWeekendRepository = raceWeekendRepository;

  final String seasonYear;
  final RaceWeekendRepository _raceWeekendRepository;

  @observable
  AsyncValue<List<RacesModel>> races = const AsyncValue.loading();

  /// Подтягивает гонки сезона.
  @action
  Future<void> load() async {
    races = races.toLoading();
    try {
      final list = await _raceWeekendRepository.seasonRaces(year: seasonYear);
      races = races.toValue(list);
    } on Object catch (error) {
      races = races.toError(error.toString());
    }
  }
}
