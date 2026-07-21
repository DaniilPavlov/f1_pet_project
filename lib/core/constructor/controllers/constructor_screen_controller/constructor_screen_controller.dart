import 'package:f1_pet_project/common/career/models/career_stats.dart';
import 'package:f1_pet_project/common/utils/helpers/async_load_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/core/constructor/loaders/constructor_career_loader.dart';
import 'package:f1_pet_project/core/espn/repositories/espn_media_repository.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/data/exceptions/custom_exception.dart';
import 'package:mobx/mobx.dart';

part 'constructor_screen_controller.g.dart';

/// MobX-контроллер экрана конструктора.
class ConstructorScreenController = ConstructorScreenControllerBase with _$ConstructorScreenController;

/// Загружает карьеру (Jolpica) и новости команды (ESPN).
abstract class ConstructorScreenControllerBase with Store {
  ConstructorScreenControllerBase({
    required this.constructor,
    required EspnMediaRepository espnMediaRepository,
    this.currentDrivers = const [],
    Future<CareerStats<DriverModel>> Function({
      required String constructorId,
      List<DriverModel> current,
    })?
    fetchCareerStats,
  }) : _espnMediaRepository = espnMediaRepository,
       _fetchCareerStatsOverride = fetchCareerStats;

  final ConstructorModel constructor;
  final List<DriverModel> currentDrivers;
  final EspnMediaRepository _espnMediaRepository;
  final Future<CareerStats<DriverModel>> Function({
    required String constructorId,
    List<DriverModel> current,
  })?
  _fetchCareerStatsOverride;

  @observable
  AsyncValue<CareerStats<DriverModel>> careerStats = const AsyncValue.loading();

  @observable
  AsyncValue<List<NewsArticleModel>> espnNews = const AsyncValue.loading();

  @computed
  CustomException? get screenError => firstException([careerStats]);

  @computed
  bool get isLoaded => careerStats.isValue && careerStats.value != null;

  @computed
  List<NewsArticleModel> get news => espnNews.value ?? const [];

  /// Загружает карьеру и ESPN-новости параллельно.
  @action
  Future<void> loadAll() async {
    await Future.wait([loadCareerStats(), loadEspnNews()]);
  }

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

  /// ESPN-новости команды (ошибка → пустой список, экран не ломаем).
  @action
  Future<void> loadEspnNews() async {
    espnNews = espnNews.toLoading();
    try {
      final data = await _espnMediaRepository.constructorNews(
        constructorId: constructor.constructorId,
        constructorName: constructor.name,
      );
      espnNews = espnNews.toValue(data);
    } on Object {
      espnNews = espnNews.toValue(const []);
    }
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
