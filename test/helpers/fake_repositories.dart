import 'package:dio/dio.dart';
import 'package:f1_pet_project/common/models/career/career_stats.dart';
import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/repositories/espn/espn_scoreboard_repository.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/repositories/wikipedia/wikipedia_page_image_repository.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/core/circuits/models/circuits_model.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/news/models/news_article_model.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_career_repository.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_career_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/results/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/core/results/finish_status/repositories/finish_status_repository.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/repositories/season_standings_repository.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/results/repositories/results_repository.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:flutter/services.dart';

import 'controller_fixtures.dart';

/// Empty asset bundle for CircuitStats / similar loaders in tests.
class EmptyTestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async => ByteData(0);

  @override
  Future<String> loadString(String key, {bool cache = true}) async => '{}';
}

class FakeCurrentStandingsRepository extends CurrentStandingsRepository {
  FakeCurrentStandingsRepository({
    StandingsModel? drivers,
    StandingsModel? constructors,
    this.fetchedFromNetwork = true,
    this.offlineFallback = false,
  }) : _drivers = drivers,
       _constructors = constructors;

  final StandingsModel? _drivers;
  final StandingsModel? _constructors;
  final bool fetchedFromNetwork;
  final bool offlineFallback;

  @override
  Future<StandingsModel> drivers() async => (await loadDrivers()).standings;

  @override
  Future<StandingsModel> constructors() async => (await loadConstructors()).standings;

  @override
  Future<StandingsLoadResult> loadDrivers() async => StandingsLoadResult(
    standings: _drivers ?? ControllerFixtures.driversStandingsModel,
    fetchedFromNetwork: fetchedFromNetwork,
    offlineFallback: offlineFallback,
  );

  @override
  Future<StandingsLoadResult> loadConstructors() async => StandingsLoadResult(
    standings: _constructors ?? ControllerFixtures.constructorsStandingsModel,
    fetchedFromNetwork: fetchedFromNetwork,
    offlineFallback: offlineFallback,
  );
}

class FakeScheduleRepository extends ScheduleRepository {
  FakeScheduleRepository({
    ScheduleModel? schedule,
    ScheduleLoadResult? result,
    this.throwOnLoad = false,
    this.fetchedFromNetwork = false,
    this.offlineFallback = false,
  }) : _schedule = schedule,
       _result = result;

  final ScheduleModel? _schedule;
  final ScheduleLoadResult? _result;
  final bool throwOnLoad;
  final bool fetchedFromNetwork;
  final bool offlineFallback;

  @override
  Future<ScheduleLoadResult> getSchedule({bool forceRefresh = false}) async {
    if (throwOnLoad) {
      throw Exception('schedule down');
    }
    if (_result != null) {
      return _result;
    }
    return ScheduleLoadResult(
      schedule: _schedule ?? ControllerFixtures.scheduleModel,
      fetchedFromNetwork: fetchedFromNetwork,
      offlineFallback: offlineFallback,
    );
  }
}

class FakeSeasonsRepository extends SeasonsRepository {
  FakeSeasonsRepository({
    this.years = const ['2024'],
    this.throwOnLoad = false,
  });

  final List<String> years;
  final bool throwOnLoad;

  @override
  Future<List<String>> getSeasonYears({bool forceRefresh = false}) async {
    if (throwOnLoad) {
      throw Exception('network');
    }
    return years;
  }
}

class FakeNewsRepository extends NewsRepository {
  FakeNewsRepository({
    this.articles = const [],
    bool? isFresh,
    this.next,
    this.throwOnLoad = false,
    this.throwOnlyForceRefresh = false,
  }) : _isFreshOverride = isFresh,
       super(dio: Dio());

  final List<NewsArticleModel> articles;
  final List<NewsArticleModel>? next;
  final bool? _isFreshOverride;
  final bool throwOnLoad;
  final bool throwOnlyForceRefresh;
  int loadCalls = 0;
  bool? lastForceRefresh;

  @override
  List<NewsArticleModel>? get peek => articles.isEmpty ? null : articles;

  @override
  bool get isFresh => _isFreshOverride ?? articles.isNotEmpty;

  @override
  Future<List<NewsArticleModel>> loadArticles({bool forceRefresh = false}) async {
    loadCalls++;
    lastForceRefresh = forceRefresh;
    if (throwOnLoad && (!throwOnlyForceRefresh || forceRefresh)) {
      throw Exception('offline');
    }
    return next ?? articles;
  }
}

class FakeCircuitsRepository extends CircuitsRepository {
  @override
  Future<CircuitsModel> all() async => ControllerFixtures.circuitsModel;

  @override
  Future<List<CircuitRaceWin>> winners({required String circuitId}) async => [
    CircuitRaceWin(
      season: '2024',
      round: '8',
      raceName: 'Monaco Grand Prix',
      driver: ControllerFixtures.driver,
      constructor: ControllerFixtures.constructor,
    ),
  ];
}

class FakeResultsRepository extends ResultsRepository {
  /// LastRaceTableSection requests `rowsNumber: 3`.
  @override
  Future<ScheduleModel> lastRace() async {
    final race = ControllerFixtures.race;
    final results = [
      for (var i = 1; i <= 3; i++)
        ResultsModel(
          number: '$i',
          position: '$i',
          positionText: '$i',
          points: '${26 - i * 7}',
          driver: ControllerFixtures.driver,
          constructor: ControllerFixtures.constructor,
          grid: '$i',
          laps: '78',
          status: 'Finished',
          time: null,
          fastestLap: null,
        ),
    ];
    return ScheduleModel(
      raceTable: RaceTableModel(
        season: race.season,
        round: race.round,
        races: [
          RacesModel(
            season: race.season,
            round: race.round,
            url: race.url,
            raceName: race.raceName,
            circuit: race.circuit,
            date: race.date,
            time: race.time,
            firstPractice: race.firstPractice,
            secondPractice: race.secondPractice,
            thirdPractice: race.thirdPractice,
            qualifying: race.qualifying,
            sprint: race.sprint,
            results: results,
            qualifyingResults: race.qualifyingResults,
            pitStops: race.pitStops,
          ),
        ],
      ),
    );
  }
}

class FakeDriverCareerRepository extends DriverCareerRepository {
  @override
  Future<CareerStats<ConstructorModel>> load({
    required String driverId,
    List<ConstructorModel> current = const [],
  }) async => CareerStats(
    races: 100,
    wins: 20,
    podiums: 40,
    poles: 15,
    current: current.isEmpty ? [ControllerFixtures.constructor] : current,
    related: [ControllerFixtures.constructor],
  );
}

class FakeConstructorCareerRepository extends ConstructorCareerRepository {
  @override
  Future<CareerStats<DriverModel>> load({
    required String constructorId,
    List<DriverModel> current = const [],
  }) async => CareerStats(
    races: 80,
    wins: 10,
    podiums: 25,
    poles: 8,
    current: current,
    related: const [],
  );
}

class FakeWikipediaPageImageRepository extends WikipediaPageImageRepository {
  @override
  Future<String?> loadThumbnail({required String articleUrl, int thumbSize = 800}) async =>
      'https://example.com/circuit.jpg';
}

class FakeDriverCatalogRepository extends DriverCatalogRepository {
  @override
  Future<List<DriverModel>> loadCurrent() async => [ControllerFixtures.driver];

  @override
  Future<List<DriverModel>> loadAll() async => [ControllerFixtures.driver];
}

class FakeConstructorCatalogRepository extends ConstructorCatalogRepository {
  @override
  Future<List<ConstructorModel>> loadCurrent() async => [ControllerFixtures.constructor];

  @override
  Future<List<ConstructorModel>> loadAll() async => [ControllerFixtures.constructor];
}

class FakeFinishStatusRepository extends FinishStatusRepository {
  @override
  Future<List<FinishStatusItem>> forSeason({required String year}) async => const [
    FinishStatusItem(statusId: '1', status: 'Finished', count: 300),
    FinishStatusItem(statusId: '2', status: 'Retired', count: 40),
  ];
}

class FakeSeasonStandingsRepository extends SeasonStandingsRepository {
  @override
  Future<StandingsModel> drivers({required String year, String? round}) async =>
      ControllerFixtures.driversStandingsModel;

  @override
  Future<StandingsModel> constructors({required String year, String? round}) async =>
      ControllerFixtures.constructorsStandingsModel;
}

class FakeRaceWeekendRepository extends RaceWeekendRepository {
  FakeRaceWeekendRepository({
    List<RacesModel>? seasonRaces,
    this.throwOnSeasonRaces = false,
  }) : _seasonRaces = seasonRaces;

  final List<RacesModel>? _seasonRaces;
  final bool throwOnSeasonRaces;

  @override
  Future<ScheduleModel> raceResults({required String year, required String round}) async =>
      ControllerFixtures.scheduleModel;

  @override
  Future<ScheduleModel> sprintResults({required String year, required String round}) async =>
      ControllerFixtures.emptyScheduleModel;

  @override
  Future<ScheduleModel> qualifyingResults({required String year, required String round}) async =>
      ControllerFixtures.scheduleModel;

  @override
  Future<ScheduleModel> pitStops({required String year, required String round}) async =>
      ControllerFixtures.scheduleModel;

  @override
  Future<List<RacesModel>> seasonRaces({required String year}) async {
    if (throwOnSeasonRaces) {
      throw Exception('boom');
    }
    return _seasonRaces ?? ControllerFixtures.scheduleModel.raceTable.races;
  }
}

class FakeEspnScoreboardRepository extends EspnScoreboardRepository {
  FakeEspnScoreboardRepository({
    this.cached,
    this.fresh = true,
    this.next,
  }) : super(dio: Dio());

  final EspnScoreboardEvent? cached;
  final bool fresh;
  final EspnScoreboardEvent? next;
  int loadCalls = 0;

  @override
  EspnScoreboardEvent? get peek => cached;

  @override
  bool get isFresh => fresh;

  @override
  Future<EspnScoreboardEvent?> loadEvent({bool forceRefresh = false}) async {
    loadCalls++;
    return next ?? cached;
  }
}
