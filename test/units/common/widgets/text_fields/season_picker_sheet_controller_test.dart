import 'package:f1_pet_project/common/widgets/text_fields/controllers/season_picker_sheet_controller/season_picker_sheet_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SeasonPickerSheetController', () {
    test('load sets years on success', () async {
      final controller = SeasonPickerSheetController(
        seasonsRepository: FakeSeasonsRepository(years: ['2025', '2024']),
      );

      await controller.load();

      expect(controller.years.isValue, isTrue);
      expect(controller.years.value, ['2025', '2024']);
    });

    test('load sets error on failure', () async {
      final controller = SeasonPickerSheetController(
        seasonsRepository: FakeSeasonsRepository(years: const [], throwOnLoad: true),
      );

      await controller.load();

      expect(controller.years.isError, isTrue);
    });
  });
}
