import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/models/espn/espn_driver_card_data.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/core/circuits/stats/circuit_stats_repository.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/results/h2h/repositories/h2h_repository.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:f1_pet_project/services/home_widget/app_widget_sync_service.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:f1_pet_project/services/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_espn_media_repository.dart';
import 'fake_repositories.dart';
import 'pump_app.dart';

/// Shared Riverpod overrides for full-screen smoke tests (tabs + detail routes).
List<Override> buildScreenSmokeOverrides({
  LiveWeekendController Function()? liveWeekend,
}) {
  final standingsRepo = FakeCurrentStandingsRepository();
  final scheduleRepo = FakeScheduleRepository();
  final seasonsRepo = FakeSeasonsRepository();
  final newsRepo = FakeNewsRepository(
    articles: const [NewsArticleModel(id: 1, headline: 'Headline', description: 'd', webUrl: 'https://espn.com/1')],
  );
  final scoreboardRepo = EspnScoreboardRepository(dio: Dio());
  final refresh = AppDataRefresh(
    requestHandler: RequestHandler(),
    standingsRepository: standingsRepo,
    scheduleRepository: scheduleRepo,
    seasonsRepository: seasonsRepo,
    newsRepository: newsRepo,
    scoreboardRepository: scoreboardRepo,
  );

  return [
    analyticsGatewayProvider.overrideWithValue(const NoOpAnalyticsGateway()),
    appDataRefreshProvider.overrideWithValue(refresh),
    seasonsRepositoryProvider.overrideWithValue(seasonsRepo),
    currentStandingsRepositoryProvider.overrideWithValue(standingsRepo),
    newsRepositoryProvider.overrideWithValue(newsRepo),
    scheduleRepositoryProvider.overrideWithValue(scheduleRepo),
    resultsRepositoryProvider.overrideWithValue(FakeResultsRepository()),
    appWidgetSyncServiceProvider.overrideWithValue(
      AppWidgetSyncService(scheduleRepository: scheduleRepo, standingsRepository: standingsRepo),
    ),
    espnScoreboardRepositoryProvider.overrideWithValue(scoreboardRepo),
    if (liveWeekend != null) liveWeekendControllerProvider.overrideWith(liveWeekend),
    espnMediaRepositoryProvider.overrideWithValue(
      FakeEspnMediaRepository(
        driverCard: const EspnDriverCardData(photoUrl: 'https://example.com/p.png'),
        constructorArticles: const [
          NewsArticleModel(id: 1, headline: 'Team', description: '', webUrl: 'https://x.com'),
        ],
      ),
    ),
    driverCareerRepositoryProvider.overrideWithValue(FakeDriverCareerRepository()),
    constructorCareerRepositoryProvider.overrideWithValue(FakeConstructorCareerRepository()),
    circuitsRepositoryProvider.overrideWithValue(FakeCircuitsRepository()),
    wikipediaPageImageRepositoryProvider.overrideWithValue(FakeWikipediaPageImageRepository()),
    circuitStatsRepositoryProvider.overrideWithValue(CircuitStatsRepository(bundle: EmptyTestAssetBundle())),
    h2hRepositoryProvider.overrideWithValue(const H2hRepository()),
    driverCatalogRepositoryProvider.overrideWithValue(FakeDriverCatalogRepository()),
    constructorCatalogRepositoryProvider.overrideWithValue(FakeConstructorCatalogRepository()),
    finishStatusRepositoryProvider.overrideWithValue(FakeFinishStatusRepository()),
    seasonStandingsRepositoryProvider.overrideWithValue(FakeSeasonStandingsRepository()),
    raceWeekendRepositoryProvider.overrideWithValue(FakeRaceWeekendRepository()),
  ];
}

extension ScreenSmokePump on WidgetTester {
  Future<void> pumpScreenSmoke(
    Widget screen, {
    List<Override>? extra,
    LiveWeekendController Function()? liveWeekend,
    Size surfaceSize = const Size(800, 2000),
  }) async {
    await pumpApp(
      screen,
      wrapInScaffold: false,
      surfaceSize: surfaceSize,
      wrapApp: (app) => ProviderScope(
        overrides: [
          ...buildScreenSmokeOverrides(liveWeekend: liveWeekend),
          ...?extra,
        ],
        child: app,
      ),
    );
    await pump();
    await pump(const Duration(milliseconds: 150));
  }
}
