import 'dart:async';

import 'package:f1_pet_project/core/circuits/controllers/circuit_screen_controller/circuit_screen_controller.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_race_win.dart';
import 'package:f1_pet_project/core/circuits/stats/circuit_stats_repository.dart';
import 'package:f1_pet_project/core/circuits/stats/models/circuit_stats.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
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

  CircuitScreenController build({
    Future<List<CircuitRaceWin>> Function({required String circuitId})? winners,
    Future<String?> Function(String articleUrl)? photo,
    Future<CircuitStats?> Function(String circuitId)? circuitStats,
  }) {
    return CircuitScreenController(
      circuit: ControllerFixtures.circuit,
      statsRepository: CircuitStatsRepository(bundle: EmptyTestAssetBundle()),
      fetchWinnersForTest: winners ?? ({required circuitId}) async => [win],
      fetchPhotoUrlForTest: photo ?? (_) async => 'https://example.com/monaco.jpg',
      fetchStatsForTest: circuitStats ?? (_) async => stats,
    );
  }

  group('CircuitScreenController', () {
    test('loadAll sets winners, photo and stats', () async {
      final controller = build();

      await controller.loadAll();

      expect(controller.isLoaded, isTrue);
      expect(controller.winners.value, hasLength(1));
      expect(controller.circuitPhotoUrl, 'https://example.com/monaco.jpg');
      expect(controller.circuitStats?.laps, 78);
      expect(controller.screenError, isNull);
    });

    test('photo and stats failures do not fail the screen', () async {
      final controller = build(
        photo: (_) async => throw Exception('wiki down'),
        circuitStats: (_) async => throw Exception('stats down'),
      );

      await controller.loadAll();

      expect(controller.isLoaded, isTrue);
      expect(controller.circuitPhotoUrl, isNull);
      expect(controller.circuitStats, isNull);
      expect(controller.screenError, isNull);
    });

    test('winners failure sets screenError', () async {
      final controller = build(winners: ({required circuitId}) async => throw ResponseParseException('fail'));

      await controller.loadWinners();

      expect(controller.winners.isError, isTrue);
      expect(controller.screenError, isNotNull);
    });

    test('photo loading flag flips while fetch is in flight', () async {
      final gate = Completer<String?>();
      final controller = build(photo: (_) => gate.future);

      final pending = controller.loadPhoto();
      expect(controller.isPhotoLoading, isTrue);

      gate.complete('https://example.com/x.jpg');
      await pending;

      expect(controller.isPhotoLoading, isFalse);
      expect(controller.circuitPhotoUrl, 'https://example.com/x.jpg');
    });

    test('refreshAll reloads winners', () async {
      var calls = 0;
      final controller = build(
        winners: ({required circuitId}) async {
          calls++;
          return [win];
        },
      );

      await controller.refreshAll();
      expect(calls, 1);
      expect(controller.isLoaded, isTrue);
    });
  });
}
