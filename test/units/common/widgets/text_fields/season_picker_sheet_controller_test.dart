import 'package:f1_pet_project/common/widgets/text_fields/controllers/season_picker_sheet_controller/season_picker_sheet_controller.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SeasonPickerSheetController', () {
    test('load sets years on success', () async {
      final container = ProviderContainer(
        overrides: [
          seasonsRepositoryProvider.overrideWithValue(FakeSeasonsRepository(years: ['2025', '2024'])),
        ],
      );
      addTearDown(container.dispose);

      await container.read(seasonPickerSheetControllerProvider.notifier).load();

      final state = container.read(seasonPickerSheetControllerProvider);
      expect(state.years.isValue, isTrue);
      expect(state.years.value, ['2025', '2024']);
    });

    test('load sets error on failure', () async {
      final container = ProviderContainer(
        overrides: [
          seasonsRepositoryProvider.overrideWithValue(
            FakeSeasonsRepository(years: const [], throwOnLoad: true),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(seasonPickerSheetControllerProvider.notifier).load();

      expect(container.read(seasonPickerSheetControllerProvider).years.isError, isTrue);
    });
  });
}
