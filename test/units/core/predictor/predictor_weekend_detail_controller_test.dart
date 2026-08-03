import 'package:f1_pet_project/core/predictor/controllers/predictor_weekend_detail_controller/predictor_weekend_detail_controller.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const weekend = PredictorWeekendPrediction(
    round: '1',
    raceName: 'Bahrain',
    qualifyingOrder: ['ver', 'lec', 'ham'],
    raceOrder: ['lec', 'ver', 'ham'],
    actualQualifyingOrder: ['ver', 'ham', 'lec'],
    actualRaceOrder: ['lec', 'ham', 'ver'],
  );

  DriverModel driver(String id) => DriverModel(
        driverId: id,
        url: '',
        givenName: id,
        familyName: id.toUpperCase(),
        dateOfBirth: '',
        nationality: '',
        code: id.substring(0, 3).toUpperCase(),
        permanentNumber: null,
      );

  group('PredictorWeekendDetailController', () {
    test('load uses cached actuals without network hooks', () async {
      var qualiCalls = 0;
      var raceCalls = 0;
      final controller = PredictorWeekendDetailController(
        season: '2026',
        weekend: weekend,
        loadDriversForTest: () async => [driver('ver'), driver('lec'), driver('ham')],
        fetchQualifyingForTest: ({required year, required round}) async {
          qualiCalls++;
          return ControllerFixtures.emptyScheduleModel;
        },
        fetchRaceResultsForTest: ({required year, required round}) async {
          raceCalls++;
          return ControllerFixtures.emptyScheduleModel;
        },
      );

      await controller.load();

      expect(controller.allDataIsLoaded, isTrue);
      expect(controller.screenError, isNull);
      expect(qualiCalls, 0);
      expect(raceCalls, 0);
      expect(controller.qualifyingCompare.value?.rows, isNotEmpty);
      expect(controller.raceCompare.value?.rows, isNotEmpty);
      expect(controller.driversById['ver']?.familyName, 'VER');
    });

    test('selectSession switches active compare', () async {
      final controller = PredictorWeekendDetailController(
        season: '2026',
        weekend: weekend,
        loadDriversForTest: () async => [driver('ver')],
        fetchQualifyingForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchRaceResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
      );
      await controller.load();

      expect(controller.selectedSession, PredictorDetailSession.qualifying);
      expect(controller.activeCompare, same(controller.qualifyingCompare.value));

      controller.selectSession(PredictorDetailSession.race);
      expect(controller.selectedSession, PredictorDetailSession.race);
      expect(controller.activeCompare, same(controller.raceCompare.value));
    });

    test('fetches actuals when cache empty and swallows catalog errors', () async {
      final race = ControllerFixtures.race;
      final scheduleWithResults = ScheduleModel(
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
              results: race.results,
              qualifyingResults: race.qualifyingResults,
              pitStops: race.pitStops,
            ),
          ],
        ),
      );

      final controller = PredictorWeekendDetailController(
        season: '2024',
        weekend: const PredictorWeekendPrediction(
          round: '1',
          raceName: 'Bahrain',
          qualifyingOrder: ['max_verstappen', 'norris'],
          raceOrder: ['max_verstappen', 'norris'],
        ),
        loadDriversForTest: () async => throw StateError('catalog down'),
        fetchQualifyingForTest: ({required year, required round}) async => scheduleWithResults,
        fetchRaceResultsForTest: ({required year, required round}) async => scheduleWithResults,
      );

      await controller.load();
      expect(controller.allDataIsLoaded, isTrue);
      expect(controller.driversById, isEmpty);
      expect(controller.qualifyingCompare.isValue, isTrue);
      expect(controller.raceCompare.isValue, isTrue);
    });

    test('refreshAll reloads', () async {
      var loads = 0;
      final controller = PredictorWeekendDetailController(
        season: '2026',
        weekend: weekend,
        loadDriversForTest: () async {
          loads++;
          return [driver('ver')];
        },
        fetchQualifyingForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchRaceResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
      );
      await controller.load();
      await controller.refreshAll();
      expect(loads, 2);
    });
  });
}
