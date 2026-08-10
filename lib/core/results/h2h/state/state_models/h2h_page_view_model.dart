import 'package:f1_pet_project/common/utils/helpers/loadable.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_compare_result.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'h2h_page_view_model.freezed.dart';

/// UI-состояние объединённого экрана H2H.
@freezed
abstract class H2hPageViewModel with _$H2hPageViewModel {
  const H2hPageViewModel._();

  const factory H2hPageViewModel({
    /// Режим сравнения (пилоты / команды).
    @Default(H2hMode.drivers) H2hMode mode,
    /// 0 — карьера, 1 — сезон.
    @Default(0) int scopeMode,
    /// В режиме сезона: true — актуальный год, false — выбор года.
    @Default(true) bool useCurrentSeason,
    /// true — только current entities, false — полный каталог.
    @Default(true) bool currentEntitiesOnly,
    /// Актуальный / выбранный сезон.
    @Default('') String latestSeason,
    /// Сезон выбран в пикере.
    @Default(false) bool seasonSelected,
    /// Первый пилот для сравнения.
    DriverModel? driverA,
    /// Второй пилот для сравнения.
    DriverModel? driverB,
    /// Первая команда для сравнения.
    ConstructorModel? constructorA,
    /// Вторая команда для сравнения.
    ConstructorModel? constructorB,
    /// Результат сравнения.
    @Default(Loadable.value()) Loadable<H2hCompareResult?> comparison,
  }) = _H2hPageViewModel;

  bool get isDriversMode => mode == H2hMode.drivers;

  bool get isSeasonScope => scopeMode == 1;

  bool get showYearPicker => isSeasonScope && !useCurrentSeason;

  CustomException? get screenError => comparison.exception;
}
