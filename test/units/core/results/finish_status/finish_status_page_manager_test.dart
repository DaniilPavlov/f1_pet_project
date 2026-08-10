import 'package:f1_pet_project/core/results/finish_status/managers/finish_status_page_manager.dart';
import 'package:f1_pet_project/core/results/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/core/results/finish_status/providers.dart';
import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_repositories.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const items = [
    FinishStatusItem(statusId: '1', status: 'Finished', count: 20),
    FinishStatusItem(statusId: '2', status: 'Retired', count: 5),
  ];

  ProviderContainer createContainer({
    FakeSeasonsRepository? seasonsRepository,
    Future<List<FinishStatusItem>> Function(String year)? fetchStatusesForTest,
  }) {
    final container = ProviderContainer(
      overrides: [
        finishStatusPageManagerProvider.overrideWith((ref) {
          final manager = FinishStatusPageManager(
            holder: ref.watch(finishStatusPageStateHolderProvider.notifier),
            seasonsRepository: seasonsRepository,
            fetchStatusesForTest: fetchStatusesForTest,
          );
          ref.onDispose(manager.dispose);
          return manager;
        }),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('FinishStatusPageManager', () {
    test('loadAllData sets statuses for valid year', () async {
      final container = createContainer(
        fetchStatusesForTest: (year) async {
          expect(year, '2024');
          return items;
        },
      );
      final manager = container.read(finishStatusPageManagerProvider);
      manager.yearController.text = '2024';

      await manager.loadAllData();

      final state = container.read(finishStatusPageStateHolderProvider);
      expect(state.isLoaded, isTrue);
      expect(state.statuses.value, hasLength(2));
      expect(state.screenError, isNull);
    });

    test('loadAllData no-ops for invalid year', () async {
      var calls = 0;
      final container = createContainer(
        fetchStatusesForTest: (_) async {
          calls++;
          return items;
        },
      );
      final manager = container.read(finishStatusPageManagerProvider);
      manager.yearController.text = '20';

      await manager.loadAllData();

      expect(calls, 0);
      expect(container.read(finishStatusPageStateHolderProvider).statuses.isLoading, isTrue);
    });

    test('loadAllData sets error on failure', () async {
      final container = createContainer(
        fetchStatusesForTest: (_) async => throw ResponseParseException('fail'),
      );
      final manager = container.read(finishStatusPageManagerProvider);
      manager.yearController.text = '2024';

      await manager.loadAllData();

      final state = container.read(finishStatusPageStateHolderProvider);
      expect(state.statuses.isError, isTrue);
      expect(state.screenError, isNotNull);
    });

    test('refreshAll reloads', () async {
      var calls = 0;
      final container = createContainer(
        fetchStatusesForTest: (_) async {
          calls++;
          return items;
        },
      );
      final manager = container.read(finishStatusPageManagerProvider);
      manager.yearController.text = '2024';

      await manager.refreshAll();
      expect(calls, 1);
      expect(container.read(finishStatusPageStateHolderProvider).isLoaded, isTrue);
    });

    test('bootstrap sets year from seasons and loads', () async {
      final container = createContainer(
        seasonsRepository: FakeSeasonsRepository(years: ['2024', '2023']),
        fetchStatusesForTest: (year) async {
          expect(year, '2024');
          return items;
        },
      );
      final manager = container.read(finishStatusPageManagerProvider);

      await manager.bootstrap();

      expect(manager.yearController.text, '2024');
      expect(container.read(finishStatusPageStateHolderProvider).isLoaded, isTrue);
    });

    test('bootstrap ignores seasons failures', () async {
      final container = createContainer(
        seasonsRepository: FakeSeasonsRepository(years: const [], throwOnLoad: true),
        fetchStatusesForTest: (_) async => items,
      );
      final manager = container.read(finishStatusPageManagerProvider);

      await manager.bootstrap();

      expect(manager.yearController.text, '2026');
      expect(container.read(finishStatusPageStateHolderProvider).isLoaded, isTrue);
    });
  });
}
