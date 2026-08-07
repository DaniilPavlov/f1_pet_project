import 'package:f1_pet_project/common/widgets/text_fields/controllers/race_picker_sheet_controller/race_picker_sheet_controller.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';
import '../../../../helpers/fake_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RacePickerSheetController', () {
    test('load sets races on success', () async {
      final container = ProviderContainer(
        overrides: [
          raceWeekendRepositoryProvider.overrideWithValue(
            FakeRaceWeekendRepository(
              seasonRaces: ControllerFixtures.scheduleModel.raceTable.races,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(racePickerSheetControllerProvider('2024').notifier).load();

      final state = container.read(racePickerSheetControllerProvider('2024'));
      expect(state.races.isValue, isTrue);
      expect(state.races.value, isNotEmpty);
    });

    test('load sets error on failure', () async {
      final container = ProviderContainer(
        overrides: [
          raceWeekendRepositoryProvider.overrideWithValue(
            FakeRaceWeekendRepository(
              seasonRaces: const [],
              throwOnSeasonRaces: true,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(racePickerSheetControllerProvider('2024').notifier).load();

      expect(container.read(racePickerSheetControllerProvider('2024')).races.isError, isTrue);
    });
  });
}
