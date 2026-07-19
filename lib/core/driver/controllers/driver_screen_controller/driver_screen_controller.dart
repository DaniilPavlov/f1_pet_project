import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/driver/loaders/driver_career_loader.dart';
import 'package:f1_pet_project/core/driver/models/driver_career_stats.dart';
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
    Future<DriverCareerStats> Function({required String driverId})? fetchCareerStats,
  }) : _fetchCareerStatsOverride = fetchCareerStats;

  final DriverModel driver;
  final Future<DriverCareerStats> Function({required String driverId})? _fetchCareerStatsOverride;

  @observable
  AsyncValue<DriverCareerStats> careerStats = const AsyncValue.loading();

  @computed
  CustomException? get screenError => firstException([careerStats]);

  @computed
  bool get isLoaded => careerStats.isValue && careerStats.value != null;

  /// Загружает (или перезагружает) карьерную статистику.
  @action
  Future<void> loadCareerStats() async {
    await runAsyncLoad(
      fetch: () => _fetchCareerStats(driverId: driver.driverId),
      getField: () => careerStats,
      setField: (value) => careerStats = value,
      onSuccess: (data) {
        if (data != null) {
          careerStats = careerStats.toValue(data);
        }
      },
    );
  }

  Future<DriverCareerStats> _fetchCareerStats({required String driverId}) {
    final override = _fetchCareerStatsOverride;
    if (override != null) {
      return override(driverId: driverId);
    }
    return DriverCareerLoader.loadData(driverId: driverId);
  }
}
