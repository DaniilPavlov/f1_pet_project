import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/models/time_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';

import 'controller_fixtures.dart';

/// Фикстуры для widget/golden: несколько строк, nationality без emoji (стабильные goldens).
abstract final class WidgetFixtures {
  static ConstructorModel get redBull => ConstructorModel(
    constructorId: 'red_bull',
    url: 'http://example.com/red_bull',
    name: 'Red Bull',
    nationality: 'Testland',
  );

  static ConstructorModel get ferrari => ConstructorModel(
    constructorId: 'ferrari',
    url: 'http://example.com/ferrari',
    name: 'Ferrari',
    nationality: 'Testland',
  );

  static DriverModel get verstappen => DriverModel(
    driverId: 'max_verstappen',
    url: 'http://example.com/max',
    givenName: 'Max',
    familyName: 'Verstappen',
    dateOfBirth: '1997-09-30',
    nationality: 'Testland',
    code: 'VER',
    permanentNumber: '1',
  );

  static DriverModel get norris => DriverModel(
    driverId: 'norris',
    url: 'http://example.com/norris',
    givenName: 'Lando',
    familyName: 'Norris',
    dateOfBirth: '1999-11-13',
    nationality: 'Testland',
    code: 'NOR',
    permanentNumber: '4',
  );

  static List<DriverStandingsModel> get driversStandings => [
    DriverStandingsModel(
      position: '1',
      positionText: '1',
      points: '100',
      wins: '3',
      driver: verstappen,
      constructors: [redBull],
    ),
    DriverStandingsModel(
      position: '2',
      positionText: '2',
      points: '80',
      wins: '1',
      driver: norris,
      constructors: [ferrari],
    ),
  ];

  static List<ConstructorStandingsModel> get constructorsStandings => [
    ConstructorStandingsModel(
      position: '1',
      positionText: '1',
      points: '200',
      wins: '5',
      constructor: redBull,
    ),
    ConstructorStandingsModel(
      position: '2',
      positionText: '2',
      points: '150',
      wins: '2',
      constructor: ferrari,
    ),
  ];

  static ResultsModel get raceResultWinner => ResultsModel(
    number: '1',
    position: '1',
    positionText: '1',
    points: '25',
    driver: verstappen,
    constructor: redBull,
    grid: '1',
    laps: '78',
    status: 'Finished',
    time: TimeModel(millis: '5400000', time: '1:30:00.000'),
    fastestLap: null,
  );

  static ResultsModel get raceResultSecond => ResultsModel(
    number: '4',
    position: '2',
    positionText: '2',
    points: '18',
    driver: norris,
    constructor: ferrari,
    grid: '2',
    laps: '78',
    status: 'Finished',
    time: TimeModel(millis: '5410000', time: '+10.000'),
    fastestLap: null,
  );

  static RacesModel get race => RacesModel(
    season: '2024',
    round: '5',
    url: 'http://example.com/race',
    raceName: 'Monaco Grand Prix',
    circuit: ControllerFixtures.circuit,
    date: '2024-05-26',
    time: '13:00:00Z',
    firstPractice: null,
    secondPractice: null,
    thirdPractice: null,
    qualifying: null,
    sprint: null,
    results: [raceResultWinner, raceResultSecond],
    qualifyingResults: null,
    pitStops: null,
  );

  static ScheduleModel get scheduleModel => ScheduleModel(
    raceTable: RaceTableModel(season: '2024', round: '5', races: [race]),
  );
}
