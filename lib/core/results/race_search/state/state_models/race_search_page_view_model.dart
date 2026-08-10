import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'race_search_page_view_model.freezed.dart';

/// UI-состояние экрана поиска гонки.
@freezed
abstract class RaceSearchPageViewModel with _$RaceSearchPageViewModel {
  const factory RaceSearchPageViewModel({
    /// Найденная гонка.
    @Default(Loadable.value()) Loadable<RacesModel?> searchedRace,
    /// Данные полностью загружены.
    @Default(true) bool dataIsLoaded,
    /// Сезон и раунд заполнены.
    @Default(false) bool fieldsInputted,
    /// Сообщение об ошибке.
    @Default('') String errorMessage,
    /// Выбранный сезон.
    @Default('') String selectedSeason,
  }) = _RaceSearchPageViewModel;
}
