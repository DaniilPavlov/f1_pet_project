import 'package:f1_pet_project/common/widgets/text_fields/controllers/race_picker_sheet_controller/race_picker_sheet_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RacePickerSheetController', () {
    test('load sets races on success', () async {
      final controller = RacePickerSheetController(
        seasonYear: '2024',
        raceWeekendRepository: FakeRaceWeekendRepository(
          seasonRaces: ControllerFixtures.scheduleModel.raceTable.races,
        ),
      );

      await controller.load();

      expect(controller.races.isValue, isTrue);
      expect(controller.races.value, isNotEmpty);
    });

    test('load sets error on failure', () async {
      final controller = RacePickerSheetController(
        seasonYear: '2024',
        raceWeekendRepository: FakeRaceWeekendRepository(
          seasonRaces: const [],
          throwOnSeasonRaces: true,
        ),
      );

      await controller.load();

      expect(controller.races.isError, isTrue);
    });
  });
}
