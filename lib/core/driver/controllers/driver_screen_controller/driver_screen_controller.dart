import 'package:f1_pet_project/common/career/models/career_stats.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/driver/repositories/driver_career_repository.dart';
import 'package:f1_pet_project/core/espn/models/espn_driver_card_data.dart';
import 'package:f1_pet_project/core/espn/repositories/espn_media_repository.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

part 'driver_screen_controller.g.dart';

/// MobX-контроллер экрана пилота.
class DriverScreenController = DriverScreenControllerBase with _$DriverScreenController;

/// Загружает карьеру (Jolpica) и ESPN-медиа пилота.
abstract class DriverScreenControllerBase with Store {
  DriverScreenControllerBase({
    required this.driver,
    required EspnMediaRepository espnMediaRepository,
    DriverCareerRepository? careerRepository,
    AppDataRefresh? dataRefresh,
    this.currentConstructors = const [],
    @visibleForTesting
    Future<CareerStats<ConstructorModel>> Function({required String driverId, List<ConstructorModel> current})?
    fetchCareerStatsForTest,
  }) : _espnMediaRepository = espnMediaRepository,
       _careerRepository = careerRepository,
       _dataRefresh = dataRefresh,
       _fetchCareerStatsForTest = fetchCareerStatsForTest;

  final DriverModel driver;
  final List<ConstructorModel> currentConstructors;
  final EspnMediaRepository _espnMediaRepository;
  final DriverCareerRepository? _careerRepository;
  final AppDataRefresh? _dataRefresh;
  final Future<CareerStats<ConstructorModel>> Function({required String driverId, List<ConstructorModel> current})?
  _fetchCareerStatsForTest;

  @observable
  AsyncValue<CareerStats<ConstructorModel>> careerStats = const AsyncValue.loading();

  @observable
  AsyncValue<EspnDriverCardData> espnCard = const AsyncValue.loading();

  @computed
  CustomException? get screenError => firstException([careerStats]);

  @computed
  bool get isLoaded => careerStats.isValue && careerStats.value != null;

  @computed
  EspnDriverCardData get espnCardData => espnCard.value ?? const EspnDriverCardData();

  @computed
  bool get isEspnLoading => espnCard.isLoading;

  /// Загружает карьеру и ESPN-данные параллельно.
  @action
  Future<void> loadAll() async {
    await Future.wait([loadCareerStats(), loadEspnCard()]);
  }

  /// Pull-to-refresh / ErrorBody: сброс кэшей и перезагрузка.
  @action
  Future<void> refreshAll() async {
    await _dataRefresh?.clearAll();
    await loadAll();
  }

  /// Загружает (или перезагружает) карьерную статистику.
  @action
  Future<void> loadCareerStats() async {
    await runAsyncLoad(
      fetch: () => _fetchCareerStats(driverId: driver.driverId, current: currentConstructors),
      getField: () => careerStats,
      setField: (value) => careerStats = value,
      onSuccess: (data) {
        if (data != null) {
          careerStats = careerStats.toValue(data);
        }
      },
    );
  }

  /// Загружает фото / флаг / новости ESPN (ошибка → пустые данные, экран не ломаем).
  @action
  Future<void> loadEspnCard() async {
    espnCard = espnCard.toLoading();
    try {
      final data = await _espnMediaRepository.driverCardData(
        givenName: driver.givenName,
        familyName: driver.familyName,
      );
      espnCard = espnCard.toValue(data);
    } on Object {
      espnCard = espnCard.toValue(const EspnDriverCardData());
    }
  }

  Future<CareerStats<ConstructorModel>> _fetchCareerStats({
    required String driverId,
    required List<ConstructorModel> current,
  }) {
    final forTest = _fetchCareerStatsForTest;
    if (forTest != null) {
      return forTest(driverId: driverId, current: current);
    }
    return _careerRepository!.load(driverId: driverId, current: current);
  }
}
