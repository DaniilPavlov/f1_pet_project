import 'package:f1_pet_project/common/career/models/career_stats.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/constructor/loaders/constructor_career_loader.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:mobx/mobx.dart';

part 'constructor_screen_controller.g.dart';

/// MobX-контроллер экрана конструктора.
class ConstructorScreenController = ConstructorScreenControllerBase with _$ConstructorScreenController;

/// Загружает карьерную статистику выбранного конструктора.
abstract class ConstructorScreenControllerBase with Store {
  ConstructorScreenControllerBase({
    required this.constructor,
    this.currentDrivers = const [],
    Future<CareerStats<DriverModel>> Function({
      required String constructorId,
      List<DriverModel> current,
    })?
    fetchCareerStats,
  }) : _fetchCareerStatsOverride = fetchCareerStats;

  final ConstructorModel constructor;
  final List<DriverModel> currentDrivers;
  final Future<CareerStats<DriverModel>> Function({
    required String constructorId,
    List<DriverModel> current,
  })?
  _fetchCareerStatsOverride;

  @observable
  AsyncValue<CareerStats<DriverModel>> careerStats = const AsyncValue.loading();

  @computed
  CustomException? get screenError => firstException([careerStats]);

  @computed
  bool get isLoaded => careerStats.isValue && careerStats.value != null;

  /// Загружает (или перезагружает) карьерную статистику.
  @action
  Future<void> loadCareerStats() async {
    await runAsyncLoad(
      fetch: () => _fetchCareerStats(constructorId: constructor.constructorId, current: currentDrivers),
      getField: () => careerStats,
      setField: (value) => careerStats = value,
      onSuccess: (data) {
        if (data != null) {
          careerStats = careerStats.toValue(data);
        }
      },
    );
  }

  Future<CareerStats<DriverModel>> _fetchCareerStats({
    required String constructorId,
    required List<DriverModel> current,
  }) {
    final override = _fetchCareerStatsOverride;
    if (override != null) {
      return override(constructorId: constructorId, current: current);
    }
    return ConstructorCareerLoader.loadData(constructorId: constructorId, current: current);
  }
}
