import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:f1_pet_project/services/cache/prefs_json_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/fake_request_handler.dart';
import '../../../helpers/jolpica_fixtures.dart';

void main() {
  setUp(() {
    CareerApiHelper.resetThrottleForTest();
    SharedPreferences.setMockInitialValues({});
  });

  group('CurrentStandingsRepository', () {
    test('drivers fetches network once then serves day cache', () async {
      final handler = FakeRequestHandler(
        responses: {
          'current/driverStandings': {
            'MRData': JolpicaFixtures.driversStandingsMrData(),
          },
        },
      );
      ApiLoader.configure(handler);

      final repo = CurrentStandingsRepository(
        driversStore: const DayPrefsJsonStore(
          dataKey: 'test_drivers_data',
          dateKey: 'test_drivers_date',
        ),
        constructorsStore: const DayPrefsJsonStore(
          dataKey: 'test_ctors_data',
          dateKey: 'test_ctors_date',
        ),
      );

      final first = await repo.drivers();
      final second = await repo.drivers();

      expect(first.standingsTable.standingsLists.first.driverStandings?.first.points, '100');
      expect(second.standingsTable.standingsLists.first.driverStandings?.first.driver.driverId, 'max_verstappen');
      expect(handler.calls.where((c) => c.path == 'current/driverStandings'), hasLength(1));
    });

    test('constructors load from network', () async {
      final handler = FakeRequestHandler(
        responses: {
          'current/constructorStandings': {
            'MRData': JolpicaFixtures.constructorsStandingsMrData(),
          },
        },
      );
      ApiLoader.configure(handler);

      final repo = CurrentStandingsRepository(
        driversStore: const DayPrefsJsonStore(
          dataKey: 'test_drivers_data2',
          dateKey: 'test_drivers_date2',
        ),
        constructorsStore: const DayPrefsJsonStore(
          dataKey: 'test_ctors_data2',
          dateKey: 'test_ctors_date2',
        ),
      );

      final standings = await repo.constructors();
      expect(
        standings.standingsTable.standingsLists.first.constructorStandings?.first.constructor.name,
        'Red Bull',
      );
    });

    test('invalidate forces network; offline falls back to stale cache', () async {
      final driversStore = const DayPrefsJsonStore(
        dataKey: 'test_drivers_stale',
        dateKey: 'test_drivers_stale_date',
      );
      await driversStore.writeToday(JolpicaFixtures.driversStandingsMrData());

      // Mark as stale day so readToday misses after invalidate.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('test_drivers_stale_date', '2000-01-01');

      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) => throw Exception('network down'),
      );
      ApiLoader.configure(handler);

      final repo = CurrentStandingsRepository(
        driversStore: driversStore,
        constructorsStore: const DayPrefsJsonStore(
          dataKey: 'unused_c',
          dateKey: 'unused_cd',
        ),
      )..invalidate();

      final standings = await repo.drivers();
      expect(
        standings.standingsTable.standingsLists.first.driverStandings?.first.wins,
        '3',
      );
    });
  });
}
