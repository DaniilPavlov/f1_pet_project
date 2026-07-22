import 'package:f1_pet_project/common/wikipedia/repositories/wikipedia_page_image_repository.dart';
import 'package:f1_pet_project/core/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/espn/repositories/espn_media_repository.dart';
import 'package:f1_pet_project/core/espn/repositories/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:f1_pet_project/services/request_handler.dart';

/// Единый контракт pull-to-refresh: сбрасывает все слои кэша приложения.
///
/// GoF Structural Facade — один метод [clearAll] закрывает подсистему из
/// многих кэшей (Dio, ESPN, catalogs, Wikipedia, prefs); UI не знает,
/// какие репозитории и в каком порядке чистить.
///
/// - Jolpica: in-memory Dio cache ([RequestHandler])
/// - ESPN TTL: news + scoreboard
/// - ESPN media: driver cards / constructor news (до clear)
/// - Catalogs: driver/constructor ESPN lookups
/// - Wikipedia thumbnails
/// - Prefs: дневной кэш schedule + seasons
class AppDataRefresh {
  AppDataRefresh({
    required RequestHandler requestHandler,
    required ScheduleRepository scheduleRepository,
    required SeasonsRepository seasonsRepository,
    required NewsRepository newsRepository,
    required EspnScoreboardRepository scoreboardRepository,
    required EspnMediaRepository mediaRepository,
    required DriverCatalogRepository driverCatalogRepository,
    required ConstructorCatalogRepository constructorCatalogRepository,
    required WikipediaPageImageRepository wikipediaRepository,
  }) : _requestHandler = requestHandler,
       _scheduleRepository = scheduleRepository,
       _seasonsRepository = seasonsRepository,
       _newsRepository = newsRepository,
       _scoreboardRepository = scoreboardRepository,
       _mediaRepository = mediaRepository,
       _driverCatalogRepository = driverCatalogRepository,
       _constructorCatalogRepository = constructorCatalogRepository,
       _wikipediaRepository = wikipediaRepository;

  final RequestHandler _requestHandler;
  final ScheduleRepository _scheduleRepository;
  final SeasonsRepository _seasonsRepository;
  final NewsRepository _newsRepository;
  final EspnScoreboardRepository _scoreboardRepository;
  final EspnMediaRepository _mediaRepository;
  final DriverCatalogRepository _driverCatalogRepository;
  final ConstructorCatalogRepository _constructorCatalogRepository;
  final WikipediaPageImageRepository _wikipediaRepository;

  /// Очищает все кэши перед принудительной перезагрузкой экрана.
  Future<void> clearAll() async {
    _requestHandler.clearCache();
    _newsRepository.clearCache();
    _scoreboardRepository.clearCache();
    _mediaRepository.clearCache();
    _driverCatalogRepository.clearCache();
    _constructorCatalogRepository.clearCache();
    _wikipediaRepository.clearCache();
    await Future.wait([
      _scheduleRepository.clearCache(),
      _seasonsRepository.clearCache(),
    ]);
  }
}
