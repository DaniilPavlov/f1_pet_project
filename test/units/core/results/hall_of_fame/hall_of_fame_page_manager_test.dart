import 'package:f1_pet_project/core/results/hall_of_fame/managers/hall_of_fame_page_manager.dart';
import 'package:f1_pet_project/core/results/hall_of_fame/providers.dart';
import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer buildContainer({
    FakeSeasonsRepository? seasonsRepository,
    Future<StandingsModel> Function(String year)? fetchDriversStandingsForTest,
    Future<StandingsModel> Function(String year)? fetchConstructorsStandingsForTest,
  }) {
    final container = ProviderContainer(
      overrides: [
        hallOfFamePageManagerProvider.overrideWith((ref) {
          final manager = HallOfFamePageManager(
            holder: ref.watch(hallOfFamePageStateHolderProvider.notifier),
            seasonsRepository: seasonsRepository,
            fetchDriversStandingsForTest: fetchDriversStandingsForTest,
            fetchConstructorsStandingsForTest: fetchConstructorsStandingsForTest,
          );
          ref.onDispose(manager.dispose);
          return manager;
        }),
      ],
    )..listen(hallOfFamePageStateHolderProvider, (_, _) {})
      ..listen(hallOfFamePageManagerProvider, (_, _) {});
    return container;
  }

  group('HallOfFamePageManager', () {
    group('checkFields', () {
      test('marks fields as valid for 4-digit year', () {
        final container = buildContainer();
        addTearDown(container.dispose);

        container.read(hallOfFamePageManagerProvider).checkFields();

        expect(container.read(hallOfFamePageStateHolderProvider).fieldsInputted, isTrue);
      });

      test('marks fields as invalid for short year', () {
        final container = buildContainer();
        addTearDown(container.dispose);

        final manager = container.read(hallOfFamePageManagerProvider);
        manager.yearController.text = '20';
        manager.checkFields();

        expect(container.read(hallOfFamePageStateHolderProvider).fieldsInputted, isFalse);
      });
    });

    group('loadDriversStandings', () {
      test('sets value on success', () async {
        final container = buildContainer(
          fetchDriversStandingsForTest: (_) async => ControllerFixtures.driversStandingsModel,
        );
        addTearDown(container.dispose);

        await container.read(hallOfFamePageManagerProvider).loadDriversStandings(year: '2024');

        final state = container.read(hallOfFamePageStateHolderProvider);
        expect(state.driversStandings.isValue, isTrue);
        expect(state.driversStandings.value, hasLength(1));
      });
    });

    group('loadAllData', () {
      test('loads standings for selected year', () async {
        final container = buildContainer(
          fetchDriversStandingsForTest: (_) async => ControllerFixtures.driversStandingsModel,
          fetchConstructorsStandingsForTest: (_) async => ControllerFixtures.constructorsStandingsModel,
        );
        addTearDown(container.dispose);

        await container.read(hallOfFamePageManagerProvider).loadAllData();

        final state = container.read(hallOfFamePageStateHolderProvider);
        expect(state.driversStandings.isValue, isTrue);
        expect(state.constructorsStandings.isValue, isTrue);
      });
    });

    test('bootstrap sets year from seasons and loads data', () async {
      final container = buildContainer(
        seasonsRepository: FakeSeasonsRepository(years: ['2024', '2023']),
        fetchDriversStandingsForTest: (_) async => ControllerFixtures.driversStandingsModel,
        fetchConstructorsStandingsForTest: (_) async => ControllerFixtures.constructorsStandingsModel,
      );
      addTearDown(container.dispose);

      final manager = container.read(hallOfFamePageManagerProvider);
      await manager.bootstrap();

      expect(manager.yearController.text, '2024');
      final state = container.read(hallOfFamePageStateHolderProvider);
      expect(state.driversStandings.isValue, isTrue);
      expect(state.constructorsStandings.isValue, isTrue);
    });

    test('refreshAll reloads both tables', () async {
      var calls = 0;
      final container = buildContainer(
        fetchDriversStandingsForTest: (_) async {
          calls++;
          return ControllerFixtures.driversStandingsModel;
        },
        fetchConstructorsStandingsForTest: (_) async {
          calls++;
          return ControllerFixtures.constructorsStandingsModel;
        },
      );
      addTearDown(container.dispose);

      await container.read(hallOfFamePageManagerProvider).refreshAll();

      expect(calls, 2);
      expect(container.read(hallOfFamePageStateHolderProvider).driversStandings.isValue, isTrue);
    });

    test('screenError when drivers standings fail', () async {
      final container = buildContainer(
        fetchDriversStandingsForTest: (_) async => throw Exception('drivers down'),
        fetchConstructorsStandingsForTest: (_) async => ControllerFixtures.constructorsStandingsModel,
      );
      addTearDown(container.dispose);

      await container.read(hallOfFamePageManagerProvider).loadDriversStandings(year: '2024');
      expect(container.read(hallOfFamePageStateHolderProvider).screenError, isNotNull);
    });
  });
}
