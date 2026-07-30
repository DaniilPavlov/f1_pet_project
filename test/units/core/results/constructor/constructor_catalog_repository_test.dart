import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_request_handler.dart';
import '../../../../helpers/jolpica_fixtures.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  group('ConstructorCatalogRepository', () {
    test('loadCurrent caches and findByConstructorId hits cache', () async {
      final handler = FakeRequestHandler(
        responses: {
          'current/constructors': JolpicaFixtures.mrDataConstructorTable(
            constructors: [JolpicaFixtures.constructorJson],
          ),
        },
      );
      ApiLoader.configure(handler);
      final repo = ConstructorCatalogRepository();

      final first = await repo.loadCurrent();
      final second = await repo.loadCurrent();

      expect(first.single.constructorId, 'red_bull');
      expect(identical(first, second), isTrue);
      expect(handler.calls.where((c) => c.path == 'current/constructors'), hasLength(1));

      expect((await repo.findByConstructorId('red_bull'))?.name, 'Red Bull');
      expect(await repo.findByConstructorId(''), isNull);
    });

    test('findByConstructorId falls back to network', () async {
      final handler = FakeRequestHandler(
        responses: {
          'current/constructors': JolpicaFixtures.mrDataConstructorTable(
            constructors: [JolpicaFixtures.constructorJson],
          ),
          'constructors/ferrari': JolpicaFixtures.mrDataConstructorTable(
            constructors: [
              {
                ...JolpicaFixtures.constructorJson,
                'constructorId': 'ferrari',
                'name': 'Ferrari',
                'nationality': 'Italian',
              },
            ],
          ),
        },
      );
      ApiLoader.configure(handler);
      final repo = ConstructorCatalogRepository();

      await repo.loadCurrent();
      final ferrari = await repo.findByConstructorId('ferrari');
      expect(ferrari?.name, 'Ferrari');
      expect(handler.calls.any((c) => c.path == 'constructors/ferrari'), isTrue);
    });

    test('loadAll sorts by name and clearCache reloads', () async {
      final handler = FakeRequestHandler(
        responses: {
          'constructors': JolpicaFixtures.mrDataConstructorTable(
            constructors: [
              {
                ...JolpicaFixtures.constructorJson,
                'constructorId': 'ferrari',
                'name': 'Ferrari',
              },
              JolpicaFixtures.constructorJson,
            ],
            total: 2,
          ),
          'current/constructors': JolpicaFixtures.mrDataConstructorTable(
            constructors: [JolpicaFixtures.constructorJson],
          ),
        },
      );
      ApiLoader.configure(handler);
      final repo = ConstructorCatalogRepository();

      final all = await repo.loadAll();
      expect(all.map((c) => c.name), ['Ferrari', 'Red Bull']);
      expect(await repo.loadAll(), same(all));

      await repo.loadCurrent();
      repo.clearCache();
      await repo.loadCurrent();
      expect(handler.calls.where((c) => c.path == 'current/constructors'), hasLength(2));
    });

    test('findByConstructorId returns null on network error', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          if (path.startsWith('constructors/')) {
            throw Exception('network');
          }
          return JolpicaFixtures.mrDataConstructorTable(constructors: const []);
        },
      );
      ApiLoader.configure(handler);
      final repo = ConstructorCatalogRepository();

      expect(await repo.findByConstructorId('unknown'), isNull);
    });

    test('loadCurrent shares in-flight and returns empty on failure', () async {
      var calls = 0;
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          calls++;
          throw Exception('boom');
        },
      );
      ApiLoader.configure(handler);
      final repo = ConstructorCatalogRepository();

      final results = await Future.wait([repo.loadCurrent(), repo.loadCurrent()]);
      expect(results[0], isEmpty);
      expect(results[1], isEmpty);
      expect(calls, 1);
    });

    test('loadAll paginates and uses all-cache for findByConstructorId', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          if (path != 'constructors') {
            throw StateError(path);
          }
          if (offset == 0) {
            return JolpicaFixtures.mrDataConstructorTable(
              constructors: [JolpicaFixtures.constructorJson],
              total: 101,
            );
          }
          return JolpicaFixtures.mrDataConstructorTable(
            constructors: [
              {
                ...JolpicaFixtures.constructorJson,
                'constructorId': 'ferrari',
                'name': 'Ferrari',
              },
            ],
            total: 101,
          );
        },
      );
      ApiLoader.configure(handler);
      final repo = ConstructorCatalogRepository();

      final all = await repo.loadAll();
      expect(all, hasLength(2));
      expect((await repo.findByConstructorId('ferrari'))?.name, 'Ferrari');
      expect(handler.calls.where((c) => c.path.startsWith('constructors/')), isEmpty);
    });
  });
}
