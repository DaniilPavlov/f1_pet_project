import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_page_view_model.freezed.dart';

/// UI-состояние главного экрана: турнирные таблицы пилотов и конструкторов.
@freezed
abstract class HomePageViewModel with _$HomePageViewModel {
  const HomePageViewModel._();

  const factory HomePageViewModel({
    /// Зачёт пилотов.
    @Default(Loadable.loading()) Loadable<List<DriverStandingsModel>> currentDrivers,
    /// Зачёт конструкторов.
    @Default(Loadable.loading()) Loadable<List<ConstructorStandingsModel>> currentConstructors,
    /// Текущий сезон.
    @Default('') String currentSeason,
    /// Текущий раунд.
    @Default('') String currentRound,
    /// Показываем кэшированные данные (офлайн).
    @Default(false) bool showingCachedData,
  }) = _HomePageViewModel;

  CustomException? get screenError => firstException([currentDrivers, currentConstructors]);
}
