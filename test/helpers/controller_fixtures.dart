import 'package:f1_pet_project/core/circuits/models/circuit_location_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_table_model.dart';
import 'package:f1_pet_project/core/circuits/models/circuits_model.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/core/home/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/core/home/models/standings/standings_model.dart';
import 'package:f1_pet_project/core/home/models/standings/standings_table_model.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';

abstract final class ControllerFixtures {
  static ConstructorModel get constructor => ConstructorModel(
    constructorId: 'red_bull',
    url: 'http://example.com/red_bull',
    name: 'Red Bull',
    nationality: 'Austrian',
  );

  static DriverModel get driver => DriverModel(
    driverId: 'max_verstappen',
    url: 'http://example.com/max',
    givenName: 'Max',
    familyName: 'Verstappen',
    dateOfBirth: '1997-09-30',
    nationality: 'Dutch',
    code: 'VER',
    permanentNumber: '1',
  );

  static CircuitModel get circuit => CircuitModel(
    circuitId: 'monaco',
    url: 'http://example.com/monaco',
    circuitName: 'Monaco',
    location: CircuitLocationModel(lat: '43.7347', long: '7.4206', locality: 'Monte Carlo', country: 'Monaco'),
  );

  static CircuitsModel get circuitsModel => CircuitsModel(circuitTable: CircuitTableModel(circuits: [circuit]));

  static StandingsModel get driversStandingsModel => StandingsModel(
    standingsTable: StandingsTableModel(
      standingsLists: [
        StandingsListsModel(
          season: '2024',
          round: '5',
          driverStandings: [
            DriverStandingsModel(
              position: '1',
              positionText: '1',
              points: '100',
              wins: '3',
              driver: driver,
              constructors: [constructor],
            ),
          ],
          constructorStandings: null,
        ),
      ],
    ),
  );

  static StandingsModel get constructorsStandingsModel => StandingsModel(
    standingsTable: StandingsTableModel(
      standingsLists: [
        StandingsListsModel(
          season: '2024',
          round: '5',
          driverStandings: null,
          constructorStandings: [
            ConstructorStandingsModel(
              position: '1',
              positionText: '1',
              points: '200',
              wins: '5',
              constructor: constructor,
            ),
          ],
        ),
      ],
    ),
  );

  static ResultsModel get raceResult => ResultsModel(
    number: '1',
    position: '1',
    positionText: '1',
    points: '25',
    driver: driver,
    constructor: constructor,
    grid: '1',
    laps: '78',
    status: 'Finished',
    time: null,
    fastestLap: null,
  );

  static PitStopsModel get pitStop =>
      PitStopsModel(driverId: 'max_verstappen', lap: '20', stop: '1', time: '14:30:00', duration: '2.5');

  static RacesModel get race => RacesModel(
    season: '2024',
    round: '5',
    url: 'http://example.com/race',
    raceName: 'Monaco Grand Prix',
    circuit: circuit,
    date: '2024-05-26',
    time: '13:00:00Z',
    firstPractice: null,
    secondPractice: null,
    thirdPractice: null,
    qualifying: null,
    sprint: null,
    results: [raceResult],
    qualifyingResults: [
      QualifyingResultsModel(
        number: '1',
        position: '1',
        driver: driver,
        constructor: constructor,
        q1: '1:10.000',
        q2: '1:09.000',
        q3: '1:08.000',
      ),
    ],
    pitStops: [pitStop],
  );

  static ScheduleModel get scheduleModel => ScheduleModel(
    raceTable: RaceTableModel(season: '2024', round: '5', races: [race]),
  );

  static ScheduleModel get emptyScheduleModel => ScheduleModel(
    raceTable: RaceTableModel(season: '2024', round: '5', races: const []),
  );
}
