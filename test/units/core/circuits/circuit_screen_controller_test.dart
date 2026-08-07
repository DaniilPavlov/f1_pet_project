import 'dart:async';

import 'package:f1_pet_project/core/circuits/controllers/circuit_screen_controller/circuit_screen_controller.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/core/circuits/stats/circuit_stats_repository.dart';
import 'package:f1_pet_project/core/circuits/stats/models/circuit_stats.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../helpers/fake_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const stats = CircuitStats(lengthKm: 3.337, laps: 78, turns: 19, topSpeedKmh: 290, elevationM: 42);

  final win = CircuitRaceWin(
    season: '2024',
    round: '8',
    raceName: 'Monaco Grand Prix',
    driver: ControllerFixtures.driver,
    constructor: ControllerFixtures.constructor,
  );

  final circuit = ControllerFixtures.circuit;

  ProviderContainer buildContainer({
    Future<List<CircuitRaceWin>> Function({required String circuitId})? winners,
    Future<String?> Function(String articleUrl)? photo,
    Future<CircuitStats?> Function(String circuitId)? circuitStats,
  }) {
    return ProviderContainer(
      overrides: [
        circuitStatsRepositoryProvider.overrideWithValue(
          CircuitStatsRepository(bundle: EmptyTestAssetBundle()),
        ),
        circuitScreenControllerProvider(circuit).overrideWith(
          () => CircuitScreenController(
            circuit,
            fetchWinnersForTest: winners ?? ({required circuitId}) async => [win],
            fetchPhotoUrlForTest: photo ?? (_) async => 'https://example.com/monaco.jpg',
            fetchStatsForTest: circuitStats ?? (_) async => stats,
          ),
        ),
      ],
    );
  }

  group('CircuitScreenController', () {
    test('loadAll sets winners, photo and stats', () async {
      final container = buildContainer();
      addTearDown(container.dispose);

      await container.read(circuitScreenControllerProvider(circuit).notifier).loadAll();
      final state = container.read(circuitScreenControllerProvider(circuit));

      expect(state.isLoaded, isTrue);
      expect(state.winners.value, hasLength(1));
      expect(state.circuitPhotoUrl, 'https://example.com/monaco.jpg');
      expect(state.circuitStats?.laps, 78);
      expect(state.screenError, isNull);
    });

    test('photo and stats failures do not fail the screen', () async {
      final container = buildContainer(
        photo: (_) async => throw Exception('wiki down'),
        circuitStats: (_) async => throw Exception('stats down'),
      );
      addTearDown(container.dispose);

      await container.read(circuitScreenControllerProvider(circuit).notifier).loadAll();
      final state = container.read(circuitScreenControllerProvider(circuit));

      expect(state.isLoaded, isTrue);
      expect(state.circuitPhotoUrl, isNull);
      expect(state.circuitStats, isNull);
      expect(state.screenError, isNull);
    });

    test('winners failure sets screenError', () async {
      final container = buildContainer(
        winners: ({required circuitId}) async => throw ResponseParseException('fail'),
      );
      addTearDown(container.dispose);

      await container.read(circuitScreenControllerProvider(circuit).notifier).loadWinners();
      final state = container.read(circuitScreenControllerProvider(circuit));

      expect(state.winners.isError, isTrue);
      expect(state.screenError, isNotNull);
    });

    test('photo loading flag flips while fetch is in flight', () async {
      final gate = Completer<String?>();
      final container = buildContainer(photo: (_) => gate.future);
      addTearDown(container.dispose);

      final controller = container.read(circuitScreenControllerProvider(circuit).notifier);
      final pending = controller.loadPhoto();
      expect(container.read(circuitScreenControllerProvider(circuit)).isPhotoLoading, isTrue);

      gate.complete('https://example.com/x.jpg');
      await pending;

      final state = container.read(circuitScreenControllerProvider(circuit));
      expect(state.isPhotoLoading, isFalse);
      expect(state.circuitPhotoUrl, 'https://example.com/x.jpg');
    });

    test('refreshAll reloads winners', () async {
      var calls = 0;
      final container = buildContainer(
        winners: ({required circuitId}) async {
          calls++;
          return [win];
        },
      );
      addTearDown(container.dispose);

      await container.read(circuitScreenControllerProvider(circuit).notifier).refreshAll();
      expect(calls, 1);
      expect(container.read(circuitScreenControllerProvider(circuit)).isLoaded, isTrue);
    });
  });
}
