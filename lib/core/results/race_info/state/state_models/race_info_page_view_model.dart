import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'race_info_page_view_model.freezed.dart';

/// UI-состояние детального экрана гонки.
@freezed
abstract class RaceInfoPageViewModel with _$RaceInfoPageViewModel {
  const RaceInfoPageViewModel._();

  const factory RaceInfoPageViewModel({
    /// Все данные загружены.
    @Default(false) bool allDataIsLoaded,
    /// Результаты спринта.
    @Default(Loadable.loading()) Loadable<List<ResultsModel>> sprintResults,
    /// Результаты квалификации.
    @Default(Loadable.loading()) Loadable<List<QualifyingResultsModel>> qualifyingResults,
    /// Пит-стопы.
    @Default(Loadable.loading()) Loadable<List<PitStopsModel>> pitStops,
  }) = _RaceInfoPageViewModel;

  CustomException? get screenError => firstException([sprintResults, qualifyingResults, pitStops]);

  /// Есть ли результаты спринта для отображения.
  bool get hasSprintResults => sprintResults.value?.isNotEmpty ?? false;
}
