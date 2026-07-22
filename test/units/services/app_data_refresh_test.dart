import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/wikipedia/repositories/wikipedia_page_image_repository.dart';
import 'package:f1_pet_project/core/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/espn/repositories/espn_media_repository.dart';
import 'package:f1_pet_project/core/espn/repositories/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/request_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppDataRefresh', () {
    test('clearAll clears jolpica, espn, catalogs, wikipedia and prefs caches', () async {
      final requestHandler = _TrackingRequestHandler();
      final schedule = _TrackingScheduleRepository();
      final seasons = _TrackingSeasonsRepository();
      final news = _TrackingNewsRepository();
      final scoreboard = _TrackingScoreboardRepository();
      final media = _TrackingMediaRepository();
      final drivers = _TrackingDriverCatalogRepository();
      final constructors = _TrackingConstructorCatalogRepository();
      final wikipedia = _TrackingWikipediaRepository();

      final refresh = AppDataRefresh(
        requestHandler: requestHandler,
        scheduleRepository: schedule,
        seasonsRepository: seasons,
        newsRepository: news,
        scoreboardRepository: scoreboard,
        mediaRepository: media,
        driverCatalogRepository: drivers,
        constructorCatalogRepository: constructors,
        wikipediaRepository: wikipedia,
      );

      await refresh.clearAll();

      expect(requestHandler.cleared, isTrue);
      expect(news.cleared, isTrue);
      expect(scoreboard.cleared, isTrue);
      expect(media.cleared, isTrue);
      expect(drivers.cleared, isTrue);
      expect(constructors.cleared, isTrue);
      expect(wikipedia.cleared, isTrue);
      expect(schedule.cleared, isTrue);
      expect(seasons.cleared, isTrue);
    });
  });
}

class _TrackingRequestHandler extends RequestHandler {
  bool cleared = false;

  @override
  void clearCache() {
    cleared = true;
  }
}

class _TrackingScheduleRepository extends ScheduleRepository {
  bool cleared = false;

  @override
  Future<void> clearCache() async {
    cleared = true;
  }
}

class _TrackingSeasonsRepository extends SeasonsRepository {
  bool cleared = false;

  @override
  Future<void> clearCache() async {
    cleared = true;
  }
}

class _TrackingNewsRepository extends NewsRepository {
  _TrackingNewsRepository() : super(dio: Dio());

  bool cleared = false;

  @override
  void clearCache() {
    cleared = true;
  }
}

class _TrackingScoreboardRepository extends EspnScoreboardRepository {
  _TrackingScoreboardRepository() : super(dio: Dio());

  bool cleared = false;

  @override
  void clearCache() {
    cleared = true;
  }
}

class _TrackingMediaRepository extends EspnMediaRepository {
  _TrackingMediaRepository() : super(dio: Dio());

  bool cleared = false;

  @override
  void clearCache() {
    cleared = true;
  }
}

class _TrackingDriverCatalogRepository extends DriverCatalogRepository {
  bool cleared = false;

  @override
  void clearCache() {
    cleared = true;
  }
}

class _TrackingConstructorCatalogRepository extends ConstructorCatalogRepository {
  bool cleared = false;

  @override
  void clearCache() {
    cleared = true;
  }
}

class _TrackingWikipediaRepository extends WikipediaPageImageRepository {
  _TrackingWikipediaRepository() : super(dio: Dio());

  bool cleared = false;

  @override
  void clearCache() {
    cleared = true;
  }
}
