import 'package:f1_pet_project/core/results/models/average_speed_model.dart';
import 'package:f1_pet_project/core/results/models/fastest_lap_model.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/results/models/time_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  ResultsModel resultWithLap(String time) => ResultsModel(
    number: '1',
    position: '1',
    positionText: '1',
    points: '25',
    driver: ControllerFixtures.driver,
    constructor: ControllerFixtures.constructor,
    grid: '1',
    laps: '78',
    status: 'Finished',
    time: null,
    fastestLap: FastestLapModel(
      rank: '1',
      lap: '40',
      time: TimeModel(millis: '1', time: time),
      averageSpeed: AverageSpeedModel(units: 'kph', speed: '200'),
    ),
  );

  group('RacesModel', () {
    test('fastestLapTime and fastestSprintLapTime pick the lowest lap', () {
      final race = RacesModel(
        season: '2024',
        round: '5',
        url: 'http://example.com',
        raceName: 'Monaco',
        circuit: ControllerFixtures.circuit,
        date: '2024-05-26',
        time: '13:00:00Z',
        firstPractice: null,
        secondPractice: null,
        thirdPractice: null,
        qualifying: null,
        sprint: null,
        results: [resultWithLap('1:21.000'), resultWithLap('1:19.500')],
        qualifyingResults: null,
        pitStops: null,
        sprintResults: [resultWithLap('1:18.000'), resultWithLap('1:20.000')],
      );

      expect(race.fastestLapTime, '1:19.500');
      expect(race.fastestSprintLapTime, '1:18.000');
      expect(RacesModel.fastestLapAmong(null), '999999');
    });

    test('fromJson throws ResponseParseException on bad payload', () {
      expect(() => RacesModel.fromJson(const {}), throwsA(isA<ResponseParseException>()));
    });
  });

  group('RaceTableModel', () {
    test('toString includes season and race count', () {
      final table = RaceTableModel(season: '2024', round: '5', races: const []);
      expect(table.toString(), contains('2024'));
      expect(table.toString(), contains('Races:'));
    });

    test('fromJson throws ResponseParseException on bad payload', () {
      expect(() => RaceTableModel.fromJson(const {}), throwsA(isA<ResponseParseException>()));
    });
  });
}
