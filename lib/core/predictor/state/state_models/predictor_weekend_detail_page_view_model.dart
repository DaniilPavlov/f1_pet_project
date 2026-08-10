import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_comparison.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'predictor_weekend_detail_page_view_model.freezed.dart';

/// Какая сессия показана на экране сравнения.
enum PredictorDetailSession { qualifying, race }

/// UI-состояние экрана сравнения предикта с фактом.
@freezed
abstract class PredictorWeekendDetailPageViewModel with _$PredictorWeekendDetailPageViewModel {
  const PredictorWeekendDetailPageViewModel._();

  const factory PredictorWeekendDetailPageViewModel({
    /// Сравнение предикта квалификации с фактом.
    @Default(Loadable.loading()) Loadable<PredictorSessionCompare> qualifyingCompare,
    /// Сравнение предикта гонки с фактом.
    @Default(Loadable.loading()) Loadable<PredictorSessionCompare> raceCompare,
    /// Пилоты по ID (для подписей).
    @Default(<String, DriverModel>{}) Map<String, DriverModel> driversById,
    /// Выбранная сессия для отображения.
    @Default(PredictorDetailSession.qualifying) PredictorDetailSession selectedSession,
    /// Все данные загружены.
    @Default(false) bool allDataIsLoaded,
  }) = _PredictorWeekendDetailPageViewModel;

  CustomException? get screenError => firstException([qualifyingCompare, raceCompare]);

  PredictorSessionCompare? get activeCompare =>
      selectedSession == PredictorDetailSession.qualifying ? qualifyingCompare.value : raceCompare.value;
}
