import 'package:f1_pet_project/app.dart';
import 'package:f1_pet_project/common/packages/mapkit_init_stub.dart'
    if (dart.library.io) 'package:f1_pet_project/common/packages/mapkit_init_io.dart' as mapkit_init;
import 'package:f1_pet_project/common/repositories/espn/espn_media_repository.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/repositories/wikipedia/wikipedia_page_image_repository.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/core/circuits/stats/circuit_stats_repository.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_leaderboard_repository.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_repository.dart';
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
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/appmetrica/appmetrica_bootstrap.dart';
import 'package:f1_pet_project/services/auth/auth_service.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:f1_pet_project/services/firebase/firebase_bootstrap.dart';
import 'package:f1_pet_project/services/home_widget/app_widget_sync_service.dart';
import 'package:f1_pet_project/services/http/app_dio.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:f1_pet_project/services/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  mapkit_init.configureMapKitPlatform();
  final remoteConfig = await bootstrapFirebase();
  await bootstrapAppMetrica();

  const AnalyticsGateway analytics = AppAnalyticsGateway();

  final requestHandler = RequestHandler();
  ApiLoader.configure(requestHandler);

  final scheduleRepository = ScheduleRepository();
  final seasonsRepository = SeasonsRepository();
  final standingsRepository = CurrentStandingsRepository();
  final driverCatalogRepository = DriverCatalogRepository();
  final constructorCatalogRepository = ConstructorCatalogRepository();
  final authService = AuthService();
  final predictorRepository = PredictorRepository(authService: authService);
  final predictorLeaderboardRepository = PredictorLeaderboardRepository(
    authService: authService,
  );
  final wikipediaRepository = WikipediaPageImageRepository();
  final espnDio = AppDio.external();
  final espnNewsDio = AppDio.external(
    connectTimeout: AppDio.connectTimeout,
    receiveTimeout: AppDio.receiveTimeout,
  );
  final scoreboardRepository = EspnScoreboardRepository(dio: espnDio);
  final newsRepository = NewsRepository(dio: espnNewsDio);
  final mediaRepository = EspnMediaRepository(dio: espnDio);
  final raceReminderService = RaceReminderService(scheduleRepository: scheduleRepository);
  final appDataRefresh = AppDataRefresh(
    requestHandler: requestHandler,
    standingsRepository: standingsRepository,
    scheduleRepository: scheduleRepository,
    seasonsRepository: seasonsRepository,
    newsRepository: newsRepository,
    scoreboardRepository: scoreboardRepository,
  );
  final appWidgetSyncService = AppWidgetSyncService(
    scheduleRepository: scheduleRepository,
    standingsRepository: standingsRepository,
  );

  runApp(
    ProviderScope(
      overrides: [
        scheduleRepositoryProvider.overrideWithValue(scheduleRepository),
        seasonsRepositoryProvider.overrideWithValue(seasonsRepository),
        circuitStatsRepositoryProvider.overrideWithValue(CircuitStatsRepository()),
        currentStandingsRepositoryProvider.overrideWithValue(standingsRepository),
        resultsRepositoryProvider.overrideWithValue(const ResultsRepository()),
        raceWeekendRepositoryProvider.overrideWithValue(const RaceWeekendRepository()),
        circuitsRepositoryProvider.overrideWithValue(const CircuitsRepository()),
        seasonStandingsRepositoryProvider.overrideWithValue(const SeasonStandingsRepository()),
        finishStatusRepositoryProvider.overrideWithValue(const FinishStatusRepository()),
        h2hRepositoryProvider.overrideWithValue(const H2hRepository()),
        driverCareerRepositoryProvider.overrideWithValue(const DriverCareerRepository()),
        constructorCareerRepositoryProvider.overrideWithValue(const ConstructorCareerRepository()),
        driverCatalogRepositoryProvider.overrideWithValue(driverCatalogRepository),
        constructorCatalogRepositoryProvider.overrideWithValue(constructorCatalogRepository),
        authServiceProvider.overrideWithValue(authService),
        predictorRepositoryProvider.overrideWithValue(predictorRepository),
        predictorLeaderboardRepositoryProvider.overrideWithValue(predictorLeaderboardRepository),
        espnScoreboardRepositoryProvider.overrideWithValue(scoreboardRepository),
        newsRepositoryProvider.overrideWithValue(newsRepository),
        espnMediaRepositoryProvider.overrideWithValue(mediaRepository),
        wikipediaPageImageRepositoryProvider.overrideWithValue(wikipediaRepository),
        appDataRefreshProvider.overrideWithValue(appDataRefresh),
        analyticsGatewayProvider.overrideWithValue(analytics),
        remoteConfigServiceProvider.overrideWithValue(remoteConfig),
        raceReminderServiceProvider.overrideWithValue(raceReminderService),
        appWidgetSyncServiceProvider.overrideWithValue(appWidgetSyncService),
      ],
      child: const App(),
    ),
  );
}
