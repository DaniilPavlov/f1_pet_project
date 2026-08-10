import 'package:f1_pet_project/core/predictor/managers/predictor_weekend_detail_page_manager.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/providers.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_weekend_detail_page_args.dart';
import 'package:f1_pet_project/core/predictor/state/state_models/predictor_weekend_detail_page_view_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  ProviderContainer buildContainer({
    required PredictorWeekendDetailPageArgs args,
    Future<ScheduleModel> Function({required String year, required String round})? fetchQualifying,
    Future<ScheduleModel> Function({required String year, required String round})? fetchRace,
    Future<List<DriverModel>> Function()? loadDrivers,
  }) {
    return ProviderContainer(
      overrides: [
        predictorWeekendDetailPageManagerProvider(args).overrideWith((ref) {
          return PredictorWeekendDetailPageManager(
            args: args,
            holder: ref.watch(predictorWeekendDetailPageStateHolderProvider(args).notifier),
            loadDriversForTest: loadDrivers,
            fetchQualifyingForTest: fetchQualifying,
            fetchRaceResultsForTest: fetchRace,
          );
        }),
      ],
    );
  }

  group('PredictorWeekendDetailPageManager', () {
    test('load uses cached actuals without network hooks', () async {
      var qualiCalls = 0;
      var raceCalls = 0;
      const args = PredictorWeekendDetailPageArgs(season: '2026', weekend: weekend);
      final container = buildContainer(
        args: args,
        loadDrivers: () async => [driver('ver'), driver('lec'), driver('ham')],
        fetchQualifying: ({required year, required round}) async {
          qualiCalls++;
          return ControllerFixtures.emptyScheduleModel;
        },
        fetchRace: ({required year, required round}) async {
          raceCalls++;
          return ControllerFixtures.emptyScheduleModel;
        },
      );
      addTearDown(container.dispose);

      await container.read(predictorWeekendDetailPageManagerProvider(args)).load();
      final state = container.read(predictorWeekendDetailPageStateHolderProvider(args));

      expect(state.allDataIsLoaded, isTrue);
      expect(state.screenError, isNull);
      expect(qualiCalls, 0);
      expect(raceCalls, 0);
      expect(state.qualifyingCompare.value?.rows, isNotEmpty);
      expect(state.raceCompare.value?.rows, isNotEmpty);
      expect(state.driversById['ver']?.familyName, 'VER');
    });

    test('selectSession switches active compare', () async {
      const args = PredictorWeekendDetailPageArgs(season: '2026', weekend: weekend);
      final container = buildContainer(
        args: args,
        loadDrivers: () async => [driver('ver')],
        fetchQualifying: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchRace: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
      );
      addTearDown(container.dispose);

      final manager = container.read(predictorWeekendDetailPageManagerProvider(args));
      await manager.load();

      var state = container.read(predictorWeekendDetailPageStateHolderProvider(args));
      expect(state.selectedSession, PredictorDetailSession.qualifying);
      expect(state.activeCompare, same(state.qualifyingCompare.value));

      manager.selectSession(PredictorDetailSession.race);
      state = container.read(predictorWeekendDetailPageStateHolderProvider(args));
      expect(state.selectedSession, PredictorDetailSession.race);
      expect(state.activeCompare, same(state.raceCompare.value));
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

      const uncached = PredictorWeekendPrediction(
        round: '1',
        raceName: 'Bahrain',
        qualifyingOrder: ['max_verstappen', 'norris'],
        raceOrder: ['max_verstappen', 'norris'],
      );
      const args = PredictorWeekendDetailPageArgs(season: '2024', weekend: uncached);
      final container = buildContainer(
        args: args,
        loadDrivers: () async => throw StateError('catalog down'),
        fetchQualifying: ({required year, required round}) async => scheduleWithResults,
        fetchRace: ({required year, required round}) async => scheduleWithResults,
      );
      addTearDown(container.dispose);

      await container.read(predictorWeekendDetailPageManagerProvider(args)).load();
      final state = container.read(predictorWeekendDetailPageStateHolderProvider(args));
      expect(state.allDataIsLoaded, isTrue);
      expect(state.driversById, isEmpty);
      expect(state.qualifyingCompare.isValue, isTrue);
      expect(state.raceCompare.isValue, isTrue);
    });

    test('refreshAll reloads', () async {
      var loads = 0;
      const args = PredictorWeekendDetailPageArgs(season: '2026', weekend: weekend);
      final container = buildContainer(
        args: args,
        loadDrivers: () async {
          loads++;
          return [driver('ver')];
        },
        fetchQualifying: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        fetchRace: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
      );
      addTearDown(container.dispose);

      final manager = container.read(predictorWeekendDetailPageManagerProvider(args));
      await manager.load();
      await manager.refreshAll();
      expect(loads, 2);
    });
  });
}
