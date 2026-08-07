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
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:f1_pet_project/services/request_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_espn_media_repository.dart';
import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/riverpod_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const career = CareerStats<DriverModel>(races: 80, wins: 10, podiums: 25, poles: 8, current: [], related: []);

  final args = ConstructorScreenArgs(constructor: ControllerFixtures.constructor);

  (ConstructorScreenController, ProviderContainer) createController({
    FakeEspnMediaRepository? espn,
    AppDataRefresh? dataRefresh,
    Future<CareerStats<DriverModel>> Function({required String constructorId, List<DriverModel> current})?
    fetchCareerStatsForTest,
    bool useCareerRepository = false,
  }) {
    late ConstructorScreenController controller;
    final container = createNotifierContainer(
      overrides: [
        if (espn != null) espnMediaRepositoryProvider.overrideWithValue(espn),
        if (useCareerRepository)
          constructorCareerRepositoryProvider.overrideWithValue(FakeConstructorCareerRepository()),
        constructorScreenControllerProvider(args).overrideWith(
          () => controller = ConstructorScreenController(
            args,
            fetchCareerStatsForTest: fetchCareerStatsForTest,
            dataRefreshForTest: dataRefresh,
          ),
        ),
      ],
    )..listen(constructorScreenControllerProvider(args), (_, _) {});
    controller = container.read(constructorScreenControllerProvider(args).notifier);
    return (controller, container);
  }

  ConstructorState stateOf(ProviderContainer container) => container.read(constructorScreenControllerProvider(args));

  group('ConstructorScreenController', () {
    test('loadAll sets career and espn news', () async {
      final espn = FakeEspnMediaRepository(
        constructorArticles: const [
          NewsArticleModel(id: 2, headline: 'Team news', description: 'd', webUrl: 'https://x.com'),
        ],
      );
      final (controller, container) = createController(espn: espn, useCareerRepository: true);

      await controller.loadAll();

      final state = stateOf(container);
      expect(state.isLoaded, isTrue);
      expect(state.careerStats.value?.wins, 10);
      expect(state.news, hasLength(1));
      expect(espn.constructorNewsCalls, 1);
    });

    test('espn failure yields empty news without failing career', () async {
      final (controller, container) = createController(
        espn: FakeEspnMediaRepository(throwOnConstructorNews: true),
        useCareerRepository: true,
      );

      await controller.loadAll();

      final state = stateOf(container);
      expect(state.isLoaded, isTrue);
      expect(state.screenError, isNull);
      expect(state.news, isEmpty);
    });

    test('career failure sets screenError', () async {
      final (controller, container) = createController(
        espn: FakeEspnMediaRepository(),
        fetchCareerStatsForTest: ({required constructorId, List<DriverModel> current = const []}) async {
          throw ResponseParseException('career failed');
        },
      );

      await controller.loadCareerStats();

      final state = stateOf(container);
      expect(state.careerStats.isError, isTrue);
      expect(state.screenError, isNotNull);
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
      final (controller, container) = createController(
        espn: FakeEspnMediaRepository(),
        dataRefresh: refresh,
        fetchCareerStatsForTest: ({required constructorId, List<DriverModel> current = const []}) async {
          calls++;
          return career;
        },
      );

      await controller.refreshAll();
      expect(calls, 1);
      expect(stateOf(container).isLoaded, isTrue);
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
