import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/models/espn/espn_driver_card_data.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_page_view_model.freezed.dart';

/// UI-состояние экрана пилота.
@freezed
abstract class DriverPageViewModel with _$DriverPageViewModel {
  const DriverPageViewModel._();

  const factory DriverPageViewModel({
    /// Карьерная статистика (тоталы и список гонок).
    @Default(Loadable.loading()) Loadable<CareerStats<ConstructorModel>> careerStats,
    /// Данные из ESPN (фото, флаг, новости).
    @Default(Loadable.loading()) Loadable<EspnDriverCardData> espnCard,
  }) = _DriverPageViewModel;

  CustomException? get screenError => firstException([careerStats]);

  bool get isLoaded => careerStats.isValue && careerStats.value != null;

  EspnDriverCardData get espnCardData => espnCard.value ?? const EspnDriverCardData();

  bool get isEspnLoading => espnCard.isLoading;
}
