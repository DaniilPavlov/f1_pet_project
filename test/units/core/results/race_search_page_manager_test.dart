import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/core/results/race_search/managers/race_search_page_manager.dart';
import 'package:f1_pet_project/core/results/race_search/providers.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const languageCode = 'ru';

  ProviderContainer createContainer({
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResultsForTest,
  }) {
    final container = ProviderContainer(
      overrides: [
        raceSearchPageManagerProvider(languageCode).overrideWith((ref) {
          final manager = RaceSearchPageManager(
            languageCode: languageCode,
            holder: ref.watch(raceSearchPageStateHolderProvider(languageCode).notifier),
            fetchRaceResultsForTest: fetchRaceResultsForTest,
            analytics: const NoOpAnalyticsGateway(),
          );
          ref.onDispose(manager.dispose);
          return manager;
        }),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('RaceSearchPageManager', () {
    group('checkFields', () {
      test('marks fields as invalid when empty', () {
        final container = createContainer();
        final manager = container.read(raceSearchPageManagerProvider(languageCode));

        manager.checkFields();

        expect(container.read(raceSearchPageStateHolderProvider(languageCode)).fieldsInputted, isFalse);
      });

      test('marks fields as valid when year and round are filled', () {
        final container = createContainer();
        final manager = container.read(raceSearchPageManagerProvider(languageCode));
        manager.yearController.text = '2024';
        manager.roundController.text = '5';

        manager.checkFields();

        expect(container.read(raceSearchPageStateHolderProvider(languageCode)).fieldsInputted, isTrue);
      });
    });

    group('loadRaceResults', () {
      test('sets value on success', () async {
        final container = createContainer(
          fetchRaceResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        );
        final manager = container.read(raceSearchPageManagerProvider(languageCode));
        manager.yearController.text = '2024';
        manager.roundController.text = '5';

        await manager.loadRaceResults();

        final state = container.read(raceSearchPageStateHolderProvider(languageCode));
        expect(state.searchedRace.isValue, isTrue);
        expect(state.searchedRace.value?.raceName, 'Monaco Grand Prix');
        expect(state.dataIsLoaded, isTrue);
        expect(state.errorMessage, isEmpty);
      });

      test('sets message when race is not found', () async {
        final container = createContainer(
          fetchRaceResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        );
        final manager = container.read(raceSearchPageManagerProvider(languageCode));
        manager.yearController.text = '2024';
        manager.roundController.text = '99';

        await manager.loadRaceResults();

        expect(
          container.read(raceSearchPageStateHolderProvider(languageCode)).errorMessage,
          'По вашему запросу гонок не найдено. Проверьте введенные данные и попробуйте еще раз.',
        );
      });

      test('sets error on failure', () async {
        final container = createContainer(
          fetchRaceResultsForTest: ({required year, required round}) async =>
              throw ResponseParseException('parse error'),
        );
        final manager = container.read(raceSearchPageManagerProvider(languageCode));
        manager.yearController.text = '2024';
        manager.roundController.text = '5';

        await manager.loadRaceResults();

        expect(container.read(raceSearchPageStateHolderProvider(languageCode)).searchedRace.isError, isTrue);
      });
    });

    test('onSeasonSelected clears race and updates selectedSeason', () {
      final container = createContainer();
      final manager = container.read(raceSearchPageManagerProvider(languageCode));
      manager.yearController.text = '2024';
      manager.roundController.text = '5';
      manager.raceDisplayController.text = 'Monaco';

      manager.onSeasonSelected();

      final state = container.read(raceSearchPageStateHolderProvider(languageCode));
      expect(state.selectedSeason, '2024');
      expect(manager.roundController.text, isEmpty);
      expect(manager.raceDisplayController.text, isEmpty);
      expect(state.fieldsInputted, isFalse);
    });

    test('onRacePicked fills round and validates fields', () {
      final container = createContainer();
      final manager = container.read(raceSearchPageManagerProvider(languageCode));
      manager.yearController.text = '2024';

      manager.onRacePicked(const RacePick(round: '7', title: 'Monaco'));

      expect(manager.roundController.text, '7');
      expect(container.read(raceSearchPageStateHolderProvider(languageCode)).fieldsInputted, isTrue);
    });
  });
}
