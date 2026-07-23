import 'package:f1_pet_project/app.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
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
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/appmetrica/appmetrica_bootstrap.dart';
import 'package:f1_pet_project/services/firebase/firebase_bootstrap.dart';
import 'package:f1_pet_project/services/firebase/remote_config_service.dart';
import 'package:f1_pet_project/services/http/app_dio.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:f1_pet_project/services/request_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  mapkit_init.configureMapKitPlatform();
  final remoteConfig = await bootstrapFirebase();
  await bootstrapAppMetrica();

  final requestHandler = RequestHandler();
  ApiLoader.configure(requestHandler);

  final scheduleRepository = ScheduleRepository();
  final seasonsRepository = SeasonsRepository();
  final driverCatalogRepository = DriverCatalogRepository();
  final constructorCatalogRepository = ConstructorCatalogRepository();
  final wikipediaRepository = WikipediaPageImageRepository();
  final espnDio = AppDio.external();
  final espnNewsDio = AppDio.external(
    connectTimeout: AppDio.connectTimeout,
    receiveTimeout: AppDio.receiveTimeout,
  );
  final scoreboardRepository = EspnScoreboardRepository(dio: espnDio);
  final newsRepository = NewsRepository(dio: espnNewsDio);
  final mediaRepository = EspnMediaRepository(dio: espnDio);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => LocaleController()),
        Provider<ScheduleRepository>.value(value: scheduleRepository),
        Provider<SeasonsRepository>.value(value: seasonsRepository),
        Provider(create: (_) => CircuitStatsRepository()),
        Provider(create: (_) => const CurrentStandingsRepository()),
        Provider(create: (_) => const ResultsRepository()),
        Provider(create: (_) => const RaceWeekendRepository()),
        Provider(create: (_) => const CircuitsRepository()),
        Provider(create: (_) => const SeasonStandingsRepository()),
        Provider(create: (_) => const FinishStatusRepository()),
        Provider(create: (_) => const H2hRepository()),
        Provider(create: (_) => const DriverCareerRepository()),
        Provider(create: (_) => const ConstructorCareerRepository()),
        Provider<DriverCatalogRepository>.value(value: driverCatalogRepository),
        Provider<ConstructorCatalogRepository>.value(value: constructorCatalogRepository),
        Provider<EspnScoreboardRepository>.value(value: scoreboardRepository),
        Provider<NewsRepository>.value(value: newsRepository),
        Provider<EspnMediaRepository>.value(value: mediaRepository),
        Provider<WikipediaPageImageRepository>.value(value: wikipediaRepository),
        Provider(
          create: (_) => AppDataRefresh(
            requestHandler: requestHandler,
            scheduleRepository: scheduleRepository,
            seasonsRepository: seasonsRepository,
            newsRepository: newsRepository,
            scoreboardRepository: scoreboardRepository,
          ),
        ),
        Provider<RemoteConfigService>.value(value: remoteConfig),
        Provider(
          create: (_) => RaceReminderService(
            scheduleRepository: scheduleRepository,
            remoteConfig: remoteConfig,
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
