import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hall_of_fame_page_view_model.freezed.dart';

/// UI-состояние экрана «Зал славы».
@freezed
abstract class HallOfFamePageViewModel with _$HallOfFamePageViewModel {
  const HallOfFamePageViewModel._();

  const factory HallOfFamePageViewModel({
    /// Зачёт пилотов.
    @Default(Loadable.loading()) Loadable<List<StandingsListsModel>> driversStandings,
    /// Зачёт конструкторов.
    @Default(Loadable.loading()) Loadable<List<StandingsListsModel>> constructorsStandings,
    /// Год заполнен и валиден.
    @Default(true) bool fieldsInputted,
  }) = _HallOfFamePageViewModel;

  CustomException? get screenError => firstException([driversStandings, constructorsStandings]);
}
