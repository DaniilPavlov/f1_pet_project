import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/core/results/constructor/managers/constructor_page_manager.dart';
import 'package:f1_pet_project/core/results/constructor/providers.dart';
import 'package:f1_pet_project/core/results/constructor/state/state_models/constructor_page_args.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const career = CareerStats<DriverModel>(races: 80, wins: 10, podiums: 25, poles: 8, current: [], related: []);

  final args = ConstructorPageArgs(constructor: ControllerFixtures.constructor);

  ProviderContainer buildContainer({
    FakeEspnMediaRepository? espn,
    AppDataRefresh? dataRefresh,
    Future<CareerStats<DriverModel>> Function({required String constructorId, List<DriverModel> current})?
    fetchCareerStatsForTest,
    bool useCareerRepository = false,
  }) {
    return ProviderContainer(
      overrides: [
        if (espn != null) espnMediaRepositoryProvider.overrideWithValue(espn),
        if (useCareerRepository)
          constructorCareerRepositoryProvider.overrideWithValue(FakeConstructorCareerRepository()),
        constructorPageManagerProvider(args).overrideWith((ref) {
          return ConstructorPageManager(
            args: args,
            holder: ref.watch(constructorPageStateHolderProvider(args).notifier),
            careerRepository: useCareerRepository ? ref.watch(constructorCareerRepositoryProvider) : null,
            espnMediaRepository: espn,
            dataRefresh: dataRefresh,
            fetchCareerStatsForTest: fetchCareerStatsForTest,
          );
        }),
      ],
    );
  }

  group('ConstructorPageManager', () {
    test('loadAll sets career and espn news', () async {
      final espn = FakeEspnMediaRepository(
        constructorArticles: const [
          NewsArticleModel(id: 2, headline: 'Team news', description: 'd', webUrl: 'https://x.com'),
        ],
      );
      final container = buildContainer(espn: espn, useCareerRepository: true);
      addTearDown(container.dispose);

      await container.read(constructorPageManagerProvider(args)).loadAll();

      final state = container.read(constructorPageStateHolderProvider(args));
      expect(state.isLoaded, isTrue);
      expect(state.careerStats.value?.wins, 10);
      expect(state.news, hasLength(1));
      expect(espn.constructorNewsCalls, 1);
    });

    test('espn failure yields empty news without failing career', () async {
      final container = buildContainer(
        espn: FakeEspnMediaRepository(throwOnConstructorNews: true),
        useCareerRepository: true,
      );
      addTearDown(container.dispose);

      await container.read(constructorPageManagerProvider(args)).loadAll();

      final state = container.read(constructorPageStateHolderProvider(args));
      expect(state.isLoaded, isTrue);
      expect(state.screenError, isNull);
      expect(state.news, isEmpty);
    });

    test('career failure sets screenError', () async {
      final container = buildContainer(
        espn: FakeEspnMediaRepository(),
        fetchCareerStatsForTest: ({required constructorId, List<DriverModel> current = const []}) async {
          throw ResponseParseException('career failed');
        },
      );
      addTearDown(container.dispose);

      await container.read(constructorPageManagerProvider(args)).loadCareerStats();

      final state = container.read(constructorPageStateHolderProvider(args));
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
      final container = buildContainer(
        espn: FakeEspnMediaRepository(),
        dataRefresh: refresh,
        fetchCareerStatsForTest: ({required constructorId, List<DriverModel> current = const []}) async {
          calls++;
          return career;
        },
      );
      addTearDown(container.dispose);

      await container.read(constructorPageManagerProvider(args)).refreshAll();
      expect(calls, 1);
      expect(container.read(constructorPageStateHolderProvider(args)).isLoaded, isTrue);
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
