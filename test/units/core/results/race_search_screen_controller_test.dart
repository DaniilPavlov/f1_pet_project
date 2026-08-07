import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../helpers/riverpod_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const languageCode = 'ru';

  (RaceSearchScreenController, ProviderContainer) createController({
    Future<ScheduleModel> Function({required String year, required String round})? fetchRaceResultsForTest,
  }) {
    late RaceSearchScreenController controller;
    final container = createNotifierContainer(
      overrides: [
        raceSearchScreenControllerProvider(languageCode).overrideWith(
          () => controller = RaceSearchScreenController(
            languageCode,
            fetchRaceResultsForTest: fetchRaceResultsForTest,
            analyticsForTest: const NoOpAnalyticsGateway(),
          ),
        ),
      ],
    )..listen(raceSearchScreenControllerProvider(languageCode), (_, _) {});
    controller = container.read(raceSearchScreenControllerProvider(languageCode).notifier);
    return (controller, container);
  }

  RaceSearchState stateOf(ProviderContainer container) =>
      container.read(raceSearchScreenControllerProvider(languageCode));

  group('RaceSearchScreenController', () {
    group('checkFields', () {
      test('marks fields as invalid when empty', () {
        final (controller, container) = createController();

        controller.checkFields();

        expect(stateOf(container).fieldsInputted, isFalse);
      });

      test('marks fields as valid when year and round are filled', () {
        final (controller, container) = createController();
        controller.yearController.text = '2024';
        controller.roundController.text = '5';

        controller.checkFields();

        expect(stateOf(container).fieldsInputted, isTrue);
      });
    });

    group('loadRaceResults', () {
      test('sets value on success', () async {
        final (controller, container) = createController(
          fetchRaceResultsForTest: ({required year, required round}) async => ControllerFixtures.scheduleModel,
        );
        controller.yearController.text = '2024';
        controller.roundController.text = '5';

        await controller.loadRaceResults();

        final state = stateOf(container);
        expect(state.searchedRace.isValue, isTrue);
        expect(state.searchedRace.value?.raceName, 'Monaco Grand Prix');
        expect(state.dataIsLoaded, isTrue);
        expect(state.errorMessage, isEmpty);
      });

      test('sets message when race is not found', () async {
        final (controller, container) = createController(
          fetchRaceResultsForTest: ({required year, required round}) async => ControllerFixtures.emptyScheduleModel,
        );
        controller.yearController.text = '2024';
        controller.roundController.text = '99';

        await controller.loadRaceResults();

        expect(
          stateOf(container).errorMessage,
          'По вашему запросу гонок не найдено. Проверьте введенные данные и попробуйте еще раз.',
        );
      });

      test('sets error on failure', () async {
        final (controller, container) = createController(
          fetchRaceResultsForTest: ({required year, required round}) async =>
              throw ResponseParseException('parse error'),
        );
        controller.yearController.text = '2024';
        controller.roundController.text = '5';

        await controller.loadRaceResults();

        expect(stateOf(container).searchedRace.isError, isTrue);
      });
    });

    test('onSeasonSelected clears race and updates selectedSeason', () {
      final (controller, container) = createController();
      controller.yearController.text = '2024';
      controller.roundController.text = '5';
      controller.raceDisplayController.text = 'Monaco';

      controller.onSeasonSelected();

      final state = stateOf(container);
      expect(state.selectedSeason, '2024');
      expect(controller.roundController.text, isEmpty);
      expect(controller.raceDisplayController.text, isEmpty);
      expect(state.fieldsInputted, isFalse);
    });

    test('onRacePicked fills round and validates fields', () {
      final (controller, container) = createController();
      controller.yearController.text = '2024';

      controller.onRacePicked(const RacePick(round: '7', title: 'Monaco'));

      expect(controller.roundController.text, '7');
      expect(stateOf(container).fieldsInputted, isTrue);
    });
  });
}
