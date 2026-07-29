import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/core/results/constructor/controllers/constructor_screen_controller/constructor_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/request_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_espn_media_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const career = CareerStats<DriverModel>(
    races: 80,
    wins: 10,
    podiums: 25,
    poles: 8,
    current: [],
    related: [],
  );

  group('ConstructorScreenController', () {
    test('loadAll sets career and espn news', () async {
      final espn = FakeEspnMediaRepository(
        constructorArticles: const [
          NewsArticleModel(id: 2, headline: 'Team news', description: 'd', webUrl: 'https://x.com'),
        ],
      );
      final controller = ConstructorScreenController(
        constructor: ControllerFixtures.constructor,
        espnMediaRepository: espn,
        fetchCareerStatsForTest: ({required constructorId, List<DriverModel> current = const []}) async => career,
      );

      await controller.loadAll();

      expect(controller.isLoaded, isTrue);
      expect(controller.careerStats.value?.wins, 10);
      expect(controller.news, hasLength(1));
      expect(espn.constructorNewsCalls, 1);
    });

    test('espn failure yields empty news without failing career', () async {
      final controller = ConstructorScreenController(
        constructor: ControllerFixtures.constructor,
        espnMediaRepository: FakeEspnMediaRepository(throwOnConstructorNews: true),
        fetchCareerStatsForTest: ({required constructorId, List<DriverModel> current = const []}) async => career,
      );

      await controller.loadAll();

      expect(controller.isLoaded, isTrue);
      expect(controller.screenError, isNull);
      expect(controller.news, isEmpty);
    });

    test('career failure sets screenError', () async {
      final controller = ConstructorScreenController(
        constructor: ControllerFixtures.constructor,
        espnMediaRepository: FakeEspnMediaRepository(),
        fetchCareerStatsForTest: ({required constructorId, List<DriverModel> current = const []}) async {
          throw ResponseParseException('career failed');
        },
      );

      await controller.loadCareerStats();

      expect(controller.careerStats.isError, isTrue);
      expect(controller.screenError, isNotNull);
    });

    test('refreshAll clears caches then reloads', () async {
      var calls = 0;
      final refresh = AppDataRefresh(
        requestHandler: _TrackingRequestHandler(),
        standingsRepository: _TrackingStandingsRepository(),
        scheduleRepository: _TrackingScheduleRepository(),
        seasonsRepository: _TrackingSeasonsRepository(),
        newsRepository: _TrackingNewsRepository(),
        scoreboardRepository: _TrackingScoreboardRepository(),
      );
      final controller = ConstructorScreenController(
        constructor: ControllerFixtures.constructor,
        espnMediaRepository: FakeEspnMediaRepository(),
        dataRefresh: refresh,
        fetchCareerStatsForTest: ({required constructorId, List<DriverModel> current = const []}) async {
          calls++;
          return career;
        },
      );

      await controller.refreshAll();
      expect(calls, 1);
      expect(controller.isLoaded, isTrue);
    });
  });
}

class _TrackingRequestHandler extends RequestHandler {
  @override
  void invalidateCache() {}
}

class _TrackingStandingsRepository extends CurrentStandingsRepository {
  @override
  void invalidate() {}
}

class _TrackingScheduleRepository extends ScheduleRepository {
  @override
  void invalidate() {}
}

class _TrackingSeasonsRepository extends SeasonsRepository {
  @override
  void invalidate() {}
}

class _TrackingNewsRepository extends NewsRepository {
  _TrackingNewsRepository() : super(dio: Dio());

  @override
  void invalidate() {}
}

class _TrackingScoreboardRepository extends EspnScoreboardRepository {
  _TrackingScoreboardRepository() : super(dio: Dio());

  @override
  void invalidate() {}
}
