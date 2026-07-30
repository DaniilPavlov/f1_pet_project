import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_request_handler.dart';
import '../../../../helpers/jolpica_fixtures.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  group('DriverCatalogRepository', () {
    test('loadCurrent caches and findByDisplayName matches full name', () async {
      final handler = FakeRequestHandler(
        responses: {
          'current/drivers': JolpicaFixtures.mrDataDriverTable(
            drivers: [JolpicaFixtures.driverJson],
          ),
        },
      );
      ApiLoader.configure(handler);
      final repo = DriverCatalogRepository();

      final first = await repo.loadCurrent();
      final second = await repo.loadCurrent();

      expect(first, hasLength(1));
      expect(identical(first, second), isTrue);
      expect(handler.calls.where((c) => c.path == 'current/drivers'), hasLength(1));

      final found = await repo.findByDisplayName('Max Verstappen');
      expect(found?.driverId, 'max_verstappen');
      expect(await repo.findByDisplayName(''), isNull);
    });

    test('findByDriverId uses cache then network', () async {
      final handler = FakeRequestHandler(
        responses: {
          'current/drivers': JolpicaFixtures.mrDataDriverTable(
            drivers: [JolpicaFixtures.driverJson],
          ),
          'drivers/charles_leclerc': JolpicaFixtures.mrDataDriverTable(
            drivers: [
              {
                ...JolpicaFixtures.driverJson,
                'driverId': 'charles_leclerc',
                'givenName': 'Charles',
                'familyName': 'Leclerc',
                'code': 'LEC',
                'permanentNumber': '16',
              },
            ],
          ),
        },
      );
      ApiLoader.configure(handler);
      final repo = DriverCatalogRepository();

      await repo.loadCurrent();
      expect((await repo.findByDriverId('max_verstappen'))?.code, 'VER');

      final lec = await repo.findByDriverId('charles_leclerc');
      expect(lec?.familyName, 'Leclerc');
      expect(handler.calls.any((c) => c.path == 'drivers/charles_leclerc'), isTrue);
      expect(await repo.findByDriverId('  '), isNull);
    });

    test('loadAll sorts by family name and caches', () async {
      final handler = FakeRequestHandler(
        responses: {
          'drivers': JolpicaFixtures.mrDataDriverTable(
            drivers: [
              {
                ...JolpicaFixtures.driverJson,
                'driverId': 'charles_leclerc',
                'givenName': 'Charles',
                'familyName': 'Leclerc',
                'code': 'LEC',
              },
              JolpicaFixtures.driverJson,
            ],
            total: 2,
          ),
        },
      );
      ApiLoader.configure(handler);
      final repo = DriverCatalogRepository();

      final all = await repo.loadAll();

      expect(all.map((d) => d.familyName), ['Leclerc', 'Verstappen']);
      expect(await repo.loadAll(), same(all));
      expect(handler.calls.where((c) => c.path == 'drivers'), hasLength(1));
    });

    test('clearCache forces reload', () async {
      final handler = FakeRequestHandler(
        responses: {
          'current/drivers': JolpicaFixtures.mrDataDriverTable(
            drivers: [JolpicaFixtures.driverJson],
          ),
        },
      );
      ApiLoader.configure(handler);
      final repo = DriverCatalogRepository();

      await repo.loadCurrent();
      repo.clearCache();
      await repo.loadCurrent();

      expect(handler.calls.where((c) => c.path == 'current/drivers'), hasLength(2));
    });

    test('findByDisplayName matches family-only and given tokens', () async {
      final handler = FakeRequestHandler(
        responses: {
          'current/drivers': JolpicaFixtures.mrDataDriverTable(
            drivers: [JolpicaFixtures.driverJson],
          ),
        },
      );
      ApiLoader.configure(handler);
      final repo = DriverCatalogRepository();

      expect((await repo.findByDisplayName('Verstappen'))?.code, 'VER');
      expect((await repo.findByDisplayName('Ma Verstappen'))?.driverId, 'max_verstappen');
      expect(await repo.findByDisplayName('Hamilton'), isNull);
    });

    test('findByDriverId returns null on network error', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          if (path.startsWith('drivers/')) {
            throw Exception('network');
          }
          return JolpicaFixtures.mrDataDriverTable(drivers: const []);
        },
      );
      ApiLoader.configure(handler);
      final repo = DriverCatalogRepository();

      expect(await repo.findByDriverId('unknown'), isNull);
    });

    test('loadCurrent shares in-flight and returns empty on failure', () async {
      var calls = 0;
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          calls++;
          if (path == 'current/drivers') {
            throw Exception('boom');
          }
          return JolpicaFixtures.mrDataDriverTable(drivers: const []);
        },
      );
      ApiLoader.configure(handler);
      final repo = DriverCatalogRepository();

      final a = repo.loadCurrent();
      final b = repo.loadCurrent();
      final results = await Future.wait([a, b]);

      expect(results[0], isEmpty);
      expect(results[1], isEmpty);
      expect(calls, 1);
    });

    test('loadAll paginates and uses all-cache for findByDriverId', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          if (path != 'drivers') {
            throw StateError(path);
          }
          if (offset == 0) {
            return JolpicaFixtures.mrDataDriverTable(
              drivers: [JolpicaFixtures.driverJson],
              total: 101,
            );
          }
          return JolpicaFixtures.mrDataDriverTable(
            drivers: [
              {
                ...JolpicaFixtures.driverJson,
                'driverId': 'charles_leclerc',
                'givenName': 'Charles',
                'familyName': 'Leclerc',
                'code': 'LEC',
              },
            ],
            total: 101,
          );
        },
      );
      ApiLoader.configure(handler);
      final repo = DriverCatalogRepository();

      final all = await repo.loadAll();
      expect(all, hasLength(2));
      expect(handler.calls.where((c) => c.path == 'drivers'), hasLength(2));

      expect((await repo.findByDriverId('charles_leclerc'))?.code, 'LEC');
      expect(handler.calls.where((c) => c.path.startsWith('drivers/')), isEmpty);
    });

    test('parse guards return empty for missing DriverTable', () async {
      final handler = FakeRequestHandler(
        responses: {
          'current/drivers': {
            'MRData': {'total': '0'},
          },
        },
      );
      ApiLoader.configure(handler);
      final repo = DriverCatalogRepository();

      expect(await repo.loadCurrent(), isEmpty);
    });
  });
}
