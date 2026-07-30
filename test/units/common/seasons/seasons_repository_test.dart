import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
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

  group('SeasonsRepository', () {
    test('getSeasonYears returns newest first and caches for the day', () async {
      final handler = FakeRequestHandler(
        responses: {
          'seasons': {'MRData': JolpicaFixtures.seasonsMrData()},
        },
      );
      ApiLoader.configure(handler);

      final repo = SeasonsRepository(
        store: const DayPrefsJsonStore(dataKey: 'seasons_data', dateKey: 'seasons_date'),
      );

      final years = await repo.getSeasonYears();
      expect(years, ['2024', '2023']);

      final cached = await repo.getSeasonYears();
      expect(cached, years);
      expect(handler.calls.where((c) => c.path == 'seasons'), hasLength(1));
    });

    test('invalidate refreshes from network', () async {
      var calls = 0;
      ApiLoader.configure(
        FakeRequestHandler(
          resolver: (path, limit, offset) {
            calls++;
            return {'MRData': JolpicaFixtures.seasonsMrData()};
          },
        ),
      );

      final repo = SeasonsRepository(
        store: const DayPrefsJsonStore(dataKey: 'seasons_data2', dateKey: 'seasons_date2'),
      );

      await repo.getSeasonYears();
      repo.invalidate();
      await repo.getSeasonYears();
      expect(calls, 2);
    });

    test('offline falls back to stale cache', () async {
      final store = const DayPrefsJsonStore(dataKey: 'seasons_stale', dateKey: 'seasons_stale_date');
      await store.writeToday(JolpicaFixtures.seasonsMrData());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('seasons_stale_date', '1999-01-01');

      ApiLoader.configure(
        FakeRequestHandler(resolver: (path, limit, offset) => throw Exception('down')),
      );

      final years = await SeasonsRepository(store: store).getSeasonYears(forceRefresh: true);
      expect(years.first, '2024');
    });
  });
}
