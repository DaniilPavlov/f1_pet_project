import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'results_page_view_model.freezed.dart';

/// UI-состояние экрана результатов: последняя гонка и офлайн-баннер.
@freezed
abstract class ResultsPageViewModel with _$ResultsPageViewModel {
  const ResultsPageViewModel._();

  const factory ResultsPageViewModel({
    /// Последняя завершённая гонка.
    @Default(Loadable.loading()) Loadable<RacesModel> lastRace,
    /// Показываем кэшированные данные (офлайн).
    @Default(false) bool showingCachedData,
  }) = _ResultsPageViewModel;

  CustomException? get screenError => lastRace.exception;
}
