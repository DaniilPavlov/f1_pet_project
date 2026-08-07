import 'package:f1_pet_project/core/results/finish_status/controllers/finish_status_screen_controller/finish_status_screen_controller.dart';
import 'package:f1_pet_project/core/results/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';
import '../../../../helpers/riverpod_container.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const items = [
    FinishStatusItem(statusId: '1', status: 'Finished', count: 20),
    FinishStatusItem(statusId: '2', status: 'Retired', count: 5),
  ];

  (FinishStatusScreenController, ProviderContainer) createController({
    FakeSeasonsRepository? seasonsRepository,
    Future<List<FinishStatusItem>> Function(String year)? fetchStatusesForTest,
  }) {
    late FinishStatusScreenController controller;
    final container = createNotifierContainer(
      overrides: [
        finishStatusScreenControllerProvider.overrideWith(
          () => controller = FinishStatusScreenController(
            seasonsRepositoryForTest: seasonsRepository,
            fetchStatusesForTest: fetchStatusesForTest,
          ),
        ),
      ],
    )..listen(finishStatusScreenControllerProvider, (_, _) {});
    controller = container.read(finishStatusScreenControllerProvider.notifier);
    return (controller, container);
  }

  group('FinishStatusScreenController', () {
    test('loadAllData sets statuses for valid year', () async {
      final (controller, container) = createController(
        fetchStatusesForTest: (year) async {
          expect(year, '2024');
          return items;
        },
      );
      controller.yearController.text = '2024';

      await controller.loadAllData();

      final state = container.read(finishStatusScreenControllerProvider);
      expect(state.isLoaded, isTrue);
      expect(state.statuses.value, hasLength(2));
      expect(state.screenError, isNull);
    });

    test('loadAllData no-ops for invalid year', () async {
      var calls = 0;
      final (controller, container) = createController(
        fetchStatusesForTest: (_) async {
          calls++;
          return items;
        },
      );
      controller.yearController.text = '20';

      await controller.loadAllData();

      expect(calls, 0);
      expect(container.read(finishStatusScreenControllerProvider).statuses.isLoading, isTrue);
    });

    test('loadAllData sets error on failure', () async {
      final (controller, container) = createController(
        fetchStatusesForTest: (_) async => throw ResponseParseException('fail'),
      );
      controller.yearController.text = '2024';

      await controller.loadAllData();

      final state = container.read(finishStatusScreenControllerProvider);
      expect(state.statuses.isError, isTrue);
      expect(state.screenError, isNotNull);
    });

    test('refreshAll reloads', () async {
      var calls = 0;
      final (controller, container) = createController(
        fetchStatusesForTest: (_) async {
          calls++;
          return items;
        },
      );
      controller.yearController.text = '2024';

      await controller.refreshAll();
      expect(calls, 1);
      expect(container.read(finishStatusScreenControllerProvider).isLoaded, isTrue);
    });

    test('bootstrap sets year from seasons and loads', () async {
      final (controller, container) = createController(
        seasonsRepository: FakeSeasonsRepository(years: ['2024', '2023']),
        fetchStatusesForTest: (year) async {
          expect(year, '2024');
          return items;
        },
      );

      await controller.bootstrap();

      expect(controller.yearController.text, '2024');
      expect(container.read(finishStatusScreenControllerProvider).isLoaded, isTrue);
    });

    test('bootstrap ignores seasons failures', () async {
      final (controller, container) = createController(
        seasonsRepository: FakeSeasonsRepository(years: const [], throwOnLoad: true),
        fetchStatusesForTest: (_) async => items,
      );

      await controller.bootstrap();

      expect(controller.yearController.text, '2026');
      expect(container.read(finishStatusScreenControllerProvider).isLoaded, isTrue);
    });
  });
}
