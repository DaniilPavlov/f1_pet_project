import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/models/espn/espn_driver_card_data.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_media_repository.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/repositories/wikipedia/wikipedia_page_image_repository.dart';
import 'package:f1_pet_project/common/utils/theme/theme_controller.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/core/circuits/stats/circuit_stats_repository.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_career_repository.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_career_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/results/finish_status/repositories/finish_status_repository.dart';
import 'package:f1_pet_project/core/results/h2h/repositories/h2h_repository.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/repositories/season_standings_repository.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/results/repositories/results_repository.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/home_widget/app_widget_sync_service.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:f1_pet_project/services/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'fake_espn_media_repository.dart';
import 'fake_repositories.dart';
import 'pump_app.dart';

/// Shared Provider graph for full-screen smoke tests (tabs + detail routes).
List<Provider> buildScreenSmokeProviders({LiveWeekendController? liveWeekend}) {
  final standingsRepo = FakeCurrentStandingsRepository();
  final scheduleRepo = FakeScheduleRepository();
  final seasonsRepo = FakeSeasonsRepository();
  final newsRepo = FakeNewsRepository(
    articles: const [NewsArticleModel(id: 1, headline: 'Headline', description: 'd', webUrl: 'https://espn.com/1')],
  );
  final refresh = AppDataRefresh(
    requestHandler: RequestHandler(),
    standingsRepository: standingsRepo,
    scheduleRepository: scheduleRepo,
    seasonsRepository: seasonsRepo,
    newsRepository: newsRepo,
    scoreboardRepository: EspnScoreboardRepository(dio: Dio()),
  );

  return [
    Provider<LocaleController>.value(value: LocaleController()),
    Provider<ThemeController>.value(value: ThemeController()),
    Provider<AnalyticsGateway>.value(value: const NoOpAnalyticsGateway()),
    Provider<AppDataRefresh>.value(value: refresh),
    Provider<SeasonsRepository>.value(value: seasonsRepo),
    Provider<CurrentStandingsRepository>.value(value: standingsRepo),
    Provider<NewsRepository>.value(value: newsRepo),
    Provider<ScheduleRepository>.value(value: scheduleRepo),
    Provider<ResultsRepository>.value(value: FakeResultsRepository()),
    Provider<AppWidgetSyncService>.value(
      value: AppWidgetSyncService(scheduleRepository: scheduleRepo, standingsRepository: standingsRepo),
    ),
    if (liveWeekend != null) Provider<LiveWeekendController>.value(value: liveWeekend),
    Provider<EspnMediaRepository>.value(
      value: FakeEspnMediaRepository(
        driverCard: const EspnDriverCardData(photoUrl: 'https://example.com/p.png'),
        constructorArticles: const [
          NewsArticleModel(id: 1, headline: 'Team', description: '', webUrl: 'https://x.com'),
        ],
      ),
    ),
    Provider<DriverCareerRepository>.value(value: FakeDriverCareerRepository()),
    Provider<ConstructorCareerRepository>.value(value: FakeConstructorCareerRepository()),
    Provider<CircuitsRepository>.value(value: FakeCircuitsRepository()),
    Provider<WikipediaPageImageRepository>.value(value: FakeWikipediaPageImageRepository()),
    Provider<CircuitStatsRepository>.value(value: CircuitStatsRepository(bundle: EmptyTestAssetBundle())),
    Provider<H2hRepository>.value(value: const H2hRepository()),
    Provider<DriverCatalogRepository>.value(value: FakeDriverCatalogRepository()),
    Provider<ConstructorCatalogRepository>.value(value: FakeConstructorCatalogRepository()),
    Provider<FinishStatusRepository>.value(value: FakeFinishStatusRepository()),
    Provider<SeasonStandingsRepository>.value(value: FakeSeasonStandingsRepository()),
    Provider<RaceWeekendRepository>.value(value: FakeRaceWeekendRepository()),
  ];
}

extension ScreenSmokePump on WidgetTester {
  Future<void> pumpScreenSmoke(
    Widget screen, {
    List<Provider>? extra,
    LiveWeekendController? liveWeekend,
    Size surfaceSize = const Size(800, 2000),
  }) async {
    await pumpApp(
      screen,
      wrapInScaffold: false,
      surfaceSize: surfaceSize,
      wrapApp: (app) => MultiProvider(
        providers: [
          ...buildScreenSmokeProviders(liveWeekend: liveWeekend),
          ...?extra,
        ],
        child: app,
      ),
    );
    await pump();
    await pump(const Duration(milliseconds: 150));
  }
}
