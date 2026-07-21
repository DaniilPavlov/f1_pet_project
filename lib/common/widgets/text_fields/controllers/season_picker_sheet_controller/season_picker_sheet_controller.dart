import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:mobx/mobx.dart';

part 'season_picker_sheet_controller.g.dart';

/// MobX-контроллер bottom sheet выбора сезона.
class SeasonPickerSheetController = SeasonPickerSheetControllerBase with _$SeasonPickerSheetController;

/// Загружает список годов сезонов.
abstract class SeasonPickerSheetControllerBase with Store {
  SeasonPickerSheetControllerBase({required SeasonsRepository seasonsRepository})
    : _seasonsRepository = seasonsRepository;

  final SeasonsRepository _seasonsRepository;

  @observable
  AsyncValue<List<String>> years = const AsyncValue.loading();

  /// Подтягивает годы (новые сверху).
  @action
  Future<void> load() async {
    years = years.toLoading();
    try {
      final data = await _seasonsRepository.getSeasonYears();
      years = years.toValue(data);
    } on Object catch (error) {
      years = years.toError(error.toString());
    }
  }
}
