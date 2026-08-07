import 'package:f1_pet_project/core/predictor/controllers/predictor_screen_controller/predictor_screen_controller.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_season.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_store.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_weekend_prediction.dart';
import 'package:f1_pet_project/core/predictor/repositories/predictor_repository.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/race_table_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_lists_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:f1_pet_project/data/models/standings/standings_table_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';

DriverModel _driver({required String id, required String code}) {
  return DriverModel(
    driverId: id,
    url: '',
    givenName: id,
    familyName: code,
    dateOfBirth: '',
    nationality: '',
    code: code,
    permanentNumber: null,
  );
}

String _codeFor(String id) {
  final padded = '${id}xxx'.substring(0, 3).toUpperCase();
  return padded;
}

RacesModel _futureRace({
  String season = '2026',
  String round = '12',
  String date = '2030-06-01',
  RaceDateModel? qualifying,
}) {
  final base = ControllerFixtures.race;
  return RacesModel(
    season: season,
    round: round,
    url: base.url,
    raceName: 'Future GP',
    circuit: base.circuit,
    date: date,
    time: '13:00:00Z',
    firstPractice: null,
    secondPractice: null,
    thirdPractice: null,
    qualifying: qualifying,
    sprint: null,
    results: const [],
    qualifyingResults: const [],
    pitStops: const [],
  );
}

StandingsModel _standings(List<String> driverIdsInOrder) {
  final constructor = ControllerFixtures.constructor;
  return StandingsModel(
    standingsTable: StandingsTableModel(
      standingsLists: [
        StandingsListsModel(
          season: '2026',
          round: '11',
          driverStandings: [
            for (var i = 0; i < driverIdsInOrder.length; i++)
              DriverStandingsModel(
                position: '${i + 1}',
                positionText: '${i + 1}',
                points: '${100 - i}',
                wins: '0',
                driver: _driver(id: driverIdsInOrder[i], code: _codeFor(driverIdsInOrder[i])),
                constructors: [constructor],
              ),
          ],
          constructorStandings: null,
        ),
      ],
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PredictorStore', () {
    test('empty / upsert / fromJson', () {
      expect(PredictorStore.empty().seasons, isEmpty);

      final weekend = const PredictorWeekendPrediction(
        round: '1',
        raceName: 'Bahrain',
        qualifyingOrder: ['a'],
        raceOrder: ['a'],
      );
      final store = PredictorStore.empty().upsertWeekend(year: '2026', weekend: weekend);
      expect(store.season('2026')?.weekends['1']?.raceName, 'Bahrain');
      expect(store.weekend(year: '2026', round: '1')?.qualifyingOrder, ['a']);

      final restored = PredictorStore.fromJson(store.toJson());
      expect(restored.weekend(year: '2026', round: '1')?.raceName, 'Bahrain');
    });
  });

  group('PredictorSeason', () {
    test('totalPoints and weekendsSorted', () {
      final season = PredictorSeason(
        year: '2026',
        weekends: {
          '2': const PredictorWeekendPrediction(
            round: '2',
            raceName: 'B',
            qualifyingOrder: [],
            raceOrder: [],
            qualiPoints: 1,
            racePoints: 2,
          ),
          '1': const PredictorWeekendPrediction(
            round: '1',
            raceName: 'A',
            qualifyingOrder: [],
            raceOrder: [],
            qualiPoints: 3,
            racePoints: 4,
          ),
        },
      );
      expect(season.totalPoints, 10);
      expect(season.weekendsSorted.map((w) => w.round).toList(), ['1', '2']);
    });
  });

  group('PredictorScreenController drafts', () {
    late PredictorRepository repo;

    setUp(() {
      repo = PredictorRepository.memory(uidProvider: () => 'uid-test');
    });

    Future<(ProviderContainer, PredictorScreenController)> buildLoaded({
      List<String> championshipIds = const ['ham', 'ver', 'lec'],
      ScheduleModel? schedule,
      PredictorRepository? repository,
    }) async {
      final drivers = championshipIds.map((id) => _driver(id: id, code: _codeFor(id))).toList();
      final container = ProviderContainer(
        overrides: [
          predictorScreenControllerProvider.overrideWith(
            () => PredictorScreenController(
              predictorRepositoryForTest: repository ?? repo,
              fetchScheduleForTest: () async =>
                  schedule ??
                  ScheduleModel(
                    raceTable: RaceTableModel(season: '2026', round: '12', races: [_futureRace()]),
                  ),
              loadDriversForTest: () async => drivers,
              fetchDriverStandingsForTest: () async => _standings(championshipIds),
              fetchQualifyingForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
              fetchRaceResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
            ),
          ),
        ],
      );
      final controller = container.read(predictorScreenControllerProvider.notifier);
      await controller.load();
      return (container, controller);
    }

    test('initial draft follows championship order', () async {
      final (container, _) = await buildLoaded(championshipIds: ['lec', 'ver', 'ham']);
      addTearDown(container.dispose);
      final state = container.read(predictorScreenControllerProvider);
      expect(state.allDataIsLoaded, isTrue);
      expect(state.screenError, isNull);
      expect(state.draftQualifyingOrder, ['lec', 'ver', 'ham']);
      expect(state.draftRaceOrder, ['lec', 'ver', 'ham']);
      expect(state.constructorsByDriverId.containsKey('lec'), isTrue);
    });

    test('moveDraftTo swaps without shifting others', () async {
      final (container, controller) = await buildLoaded(championshipIds: ['a', 'b', 'c', 'd']);
      addTearDown(container.dispose);
      // a b c d → swap index 0 with 2 → c b a d
      await controller.moveDraftTo(fromIndex: 0, toIndex: 2);
      expect(container.read(predictorScreenControllerProvider).draftQualifyingOrder, ['c', 'b', 'a', 'd']);
    });

    test('copyQualifyingToRace copies current quali draft', () async {
      final (container, controller) = await buildLoaded(championshipIds: ['a', 'b', 'c']);
      addTearDown(container.dispose);
      await controller.moveDraftTo(fromIndex: 0, toIndex: 2);
      controller.selectGrid(PredictorGridKind.race);
      await controller.copyQualifyingToRace();
      final state = container.read(predictorScreenControllerProvider);
      expect(state.draftRaceOrder, state.draftQualifyingOrder);
      expect(state.draftRaceOrder, ['c', 'b', 'a']);
    });

    test('reorderDraft inserts with shift', () async {
      final (container, controller) = await buildLoaded(championshipIds: ['a', 'b', 'c']);
      addTearDown(container.dispose);
      await controller.reorderDraft(oldIndex: 0, newIndex: 2);
      // remove a → [b,c], insert at 2 → [b,c,a]
      expect(container.read(predictorScreenControllerProvider).draftQualifyingOrder, ['b', 'c', 'a']);
    });

    test('storage load error becomes screenError', () async {
      final (container, _) = await buildLoaded(
        championshipIds: ['a'],
        repository: _ThrowingPredictorRepository(),
      );
      addTearDown(container.dispose);
      final state = container.read(predictorScreenControllerProvider);
      expect(state.screenError, isNotNull);
      expect(state.allDataIsLoaded, isFalse);
      expect(state.predictions.isError, isTrue);
    });

    test('no upcoming race clears drafts', () async {
      final (container, _) = await buildLoaded(schedule: ControllerFixtures.emptyScheduleModel);
      addTearDown(container.dispose);
      final state = container.read(predictorScreenControllerProvider);
      expect(state.upcomingRace, isNull);
      expect(state.draftQualifyingOrder, isEmpty);
    });
  });
}

/// Test double: [load] always fails.
class _ThrowingPredictorRepository extends PredictorRepository {
  _ThrowingPredictorRepository() : super.memory(uidProvider: () => 'uid');

  @override
  Future<PredictorStore> load() async {
    throw StateError('firestore down');
  }
}
