import 'package:f1_pet_project/core/results/hall_of_fame/controllers/hall_of_fame_screen_controller/hall_of_fame_screen_controller.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/riverpod_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  (HallOfFameScreenController, ProviderContainer) createController({
    FakeSeasonsRepository? seasonsRepository,
    Future<StandingsModel> Function(String year)? fetchDriversStandingsForTest,
    Future<StandingsModel> Function(String year)? fetchConstructorsStandingsForTest,
  }) {
    late HallOfFameScreenController controller;
    final container = createNotifierContainer(
      overrides: [
        hallOfFameScreenControllerProvider.overrideWith(
          () => controller = HallOfFameScreenController(
            seasonsRepositoryForTest: seasonsRepository,
            fetchDriversStandingsForTest: fetchDriversStandingsForTest,
            fetchConstructorsStandingsForTest: fetchConstructorsStandingsForTest,
          ),
        ),
      ],
    )..listen(hallOfFameScreenControllerProvider, (_, _) {});
    controller = container.read(hallOfFameScreenControllerProvider.notifier);
    return (controller, container);
  }

  group('HallOfFameScreenController', () {
    group('checkFields', () {
      test('marks fields as valid for 4-digit year', () {
        final (controller, container) = createController();

        controller.checkFields();

        expect(container.read(hallOfFameScreenControllerProvider).fieldsInputted, isTrue);
      });

      test('marks fields as invalid for short year', () {
        final (controller, container) = createController();
        controller.yearController.text = '20';

        controller.checkFields();

        expect(container.read(hallOfFameScreenControllerProvider).fieldsInputted, isFalse);
      });
    });

    group('loadDriversStandings', () {
      test('sets value on success', () async {
        final (controller, container) = createController(
          fetchDriversStandingsForTest: (_) async => ControllerFixtures.driversStandingsModel,
        );

        await controller.loadDriversStandings(year: '2024');

        final state = container.read(hallOfFameScreenControllerProvider);
        expect(state.driversStandings.isValue, isTrue);
        expect(state.driversStandings.value, hasLength(1));
      });
    });

    group('loadAllData', () {
      test('loads standings for selected year', () async {
        final (controller, container) = createController(
          fetchDriversStandingsForTest: (_) async => ControllerFixtures.driversStandingsModel,
          fetchConstructorsStandingsForTest: (_) async => ControllerFixtures.constructorsStandingsModel,
        );

        await controller.loadAllData();

        final state = container.read(hallOfFameScreenControllerProvider);
        expect(state.driversStandings.isValue, isTrue);
        expect(state.constructorsStandings.isValue, isTrue);
      });
    });

    test('bootstrap sets year from seasons and loads data', () async {
      final (controller, container) = createController(
        seasonsRepository: FakeSeasonsRepository(years: ['2024', '2023']),
        fetchDriversStandingsForTest: (_) async => ControllerFixtures.driversStandingsModel,
        fetchConstructorsStandingsForTest: (_) async => ControllerFixtures.constructorsStandingsModel,
      );

      await controller.bootstrap();

      expect(controller.yearController.text, '2024');
      final state = container.read(hallOfFameScreenControllerProvider);
      expect(state.driversStandings.isValue, isTrue);
      expect(state.constructorsStandings.isValue, isTrue);
    });

    test('refreshAll reloads both tables', () async {
      var calls = 0;
      final (controller, container) = createController(
        fetchDriversStandingsForTest: (_) async {
          calls++;
          return ControllerFixtures.driversStandingsModel;
        },
        fetchConstructorsStandingsForTest: (_) async {
          calls++;
          return ControllerFixtures.constructorsStandingsModel;
        },
      );

      await controller.refreshAll();

      expect(calls, 2);
      expect(container.read(hallOfFameScreenControllerProvider).driversStandings.isValue, isTrue);
    });

    test('screenError when drivers standings fail', () async {
      final (controller, container) = createController(
        fetchDriversStandingsForTest: (_) async => throw Exception('drivers down'),
        fetchConstructorsStandingsForTest: (_) async => ControllerFixtures.constructorsStandingsModel,
      );

      await controller.loadDriversStandings(year: '2024');
      expect(container.read(hallOfFameScreenControllerProvider).screenError, isNotNull);
    });
  });
}
