import 'package:f1_pet_project/core/results/finish_status/controllers/finish_status_screen_controller/finish_status_screen_controller.dart';
import 'package:f1_pet_project/core/results/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../helpers/fake_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const items = [
    FinishStatusItem(statusId: '1', status: 'Finished', count: 20),
    FinishStatusItem(statusId: '2', status: 'Retired', count: 5),
  ];

  group('FinishStatusScreenController', () {
    test('loadAllData sets statuses for valid year', () async {
      final controller = FinishStatusScreenController(
        fetchStatusesForTest: (year) async {
          expect(year, '2024');
          return items;
        },
      )..yearController.text = '2024';

      await controller.loadAllData();

      expect(controller.isLoaded, isTrue);
      expect(controller.statuses.value, hasLength(2));
      expect(controller.screenError, isNull);
      controller.dispose();
    });

    test('loadAllData no-ops for invalid year', () async {
      var calls = 0;
      final controller = FinishStatusScreenController(
        fetchStatusesForTest: (_) async {
          calls++;
          return items;
        },
      )..yearController.text = '20';

      await controller.loadAllData();

      expect(calls, 0);
      expect(controller.statuses.isLoading, isTrue);
      controller.dispose();
    });

    test('loadAllData sets error on failure', () async {
      final controller = FinishStatusScreenController(
        fetchStatusesForTest: (_) async => throw ResponseParseException('fail'),
      )..yearController.text = '2024';

      await controller.loadAllData();

      expect(controller.statuses.isError, isTrue);
      expect(controller.screenError, isNotNull);
      controller.dispose();
    });

    test('refreshAll reloads', () async {
      var calls = 0;
      final controller = FinishStatusScreenController(
        fetchStatusesForTest: (_) async {
          calls++;
          return items;
        },
      )..yearController.text = '2024';

      await controller.refreshAll();
      expect(calls, 1);
      expect(controller.isLoaded, isTrue);
      controller.dispose();
    });

    test('bootstrap sets year from seasons and loads', () async {
      final controller = FinishStatusScreenController(
        seasonsRepository: FakeSeasonsRepository(years: ['2024', '2023']),
        fetchStatusesForTest: (year) async {
          expect(year, '2024');
          return items;
        },
      );

      await controller.bootstrap();

      expect(controller.yearController.text, '2024');
      expect(controller.isLoaded, isTrue);
      controller.dispose();
    });

    test('bootstrap ignores seasons failures', () async {
      final controller = FinishStatusScreenController(
        seasonsRepository: FakeSeasonsRepository(years: const [], throwOnLoad: true),
        fetchStatusesForTest: (_) async => items,
      );

      await controller.bootstrap();

      expect(controller.yearController.text, '2026');
      expect(controller.isLoaded, isTrue);
      controller.dispose();
    });
  });
}
