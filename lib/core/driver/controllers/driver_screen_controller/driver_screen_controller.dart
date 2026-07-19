import 'package:f1_pet_project/common/career/models/career_stats.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/driver/loaders/driver_career_loader.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:mobx/mobx.dart';

part 'driver_screen_controller.g.dart';

/// MobX-контроллер экрана пилота.
class DriverScreenController = DriverScreenControllerBase with _$DriverScreenController;

/// Загружает карьерную статистику выбранного пилота.
abstract class DriverScreenControllerBase with Store {
  DriverScreenControllerBase({
    required this.driver,
    this.currentConstructors = const [],
    Future<CareerStats<ConstructorModel>> Function({
      required String driverId,
      List<ConstructorModel> current,
    })?
    fetchCareerStats,
  }) : _fetchCareerStatsOverride = fetchCareerStats;

  final DriverModel driver;
  final List<ConstructorModel> currentConstructors;
  final Future<CareerStats<ConstructorModel>> Function({
    required String driverId,
    List<ConstructorModel> current,
  })?
  _fetchCareerStatsOverride;

  @observable
  AsyncValue<CareerStats<ConstructorModel>> careerStats = const AsyncValue.loading();

  @computed
  CustomException? get screenError => firstException([careerStats]);

  @computed
  bool get isLoaded => careerStats.isValue && careerStats.value != null;

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

  Future<CareerStats<ConstructorModel>> _fetchCareerStats({
    required String driverId,
    required List<ConstructorModel> current,
  }) {
    final override = _fetchCareerStatsOverride;
    if (override != null) {
      return override(driverId: driverId, current: current);
    }
    return DriverCareerLoader.loadData(driverId: driverId, current: current);
  }
}
