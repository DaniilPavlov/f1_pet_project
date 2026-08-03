import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/common/utils/helpers/network_reachability.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
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
    NetworkReachability.debugIsOfflineOverride = () async => false;
  });

  tearDown(() {
    NetworkReachability.debugIsOfflineOverride = null;
  });

  group('ScheduleRepository', () {
    test('getSchedule caches for the day and collapses in-flight', () async {
      var calls = 0;
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          calls++;
          expect(path, 'current');
          return {
            'MRData': JolpicaFixtures.scheduleMrData(),
          };
        },
      );
      ApiLoader.configure(handler);

      final repo = ScheduleRepository(
        store: const DayPrefsJsonStore(dataKey: 'sched_data', dateKey: 'sched_date'),
      );

      final results = await Future.wait([
        repo.getSchedule(),
        repo.getSchedule(),
      ]);

      expect(results[0].fetchedFromNetwork, isTrue);
      expect(results[1].fetchedFromNetwork, isTrue); // same in-flight future
      expect(calls, 1);
      expect(results[0].schedule.raceTable.races, hasLength(1));

      final cached = await repo.getSchedule();
      expect(cached.fetchedFromNetwork, isFalse);
      expect(calls, 1);
    });

    test('forceRefresh / invalidate hits network again', () async {
      var calls = 0;
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) {
          calls++;
          return {'MRData': JolpicaFixtures.scheduleMrData()};
        },
      );
      ApiLoader.configure(handler);

      final repo = ScheduleRepository(
        store: const DayPrefsJsonStore(dataKey: 'sched_data2', dateKey: 'sched_date2'),
      );

      await repo.getSchedule();
      repo.invalidate();
      final refreshed = await repo.getSchedule();

      expect(refreshed.fetchedFromNetwork, isTrue);
      expect(calls, 2);
    });

    test('clearCache then offline without cache rethrows', () async {
      final handler = FakeRequestHandler(
        resolver: (path, limit, offset) => throw Exception('down'),
      );
      ApiLoader.configure(handler);

      final repo = ScheduleRepository(
        store: const DayPrefsJsonStore(dataKey: 'sched_empty', dateKey: 'sched_empty_date'),
      );
      await repo.clearCache();

      expect(() => repo.getSchedule(forceRefresh: true), throwsA(isA<Exception>()));
    });

    test('network failure falls back to stale prefs', () async {
      final store = const DayPrefsJsonStore(dataKey: 'sched_stale', dateKey: 'sched_stale_date');
      await store.writeToday(JolpicaFixtures.scheduleMrData());
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sched_stale_date', '1999-01-01');
      NetworkReachability.debugIsOfflineOverride = () async => true;

      ApiLoader.configure(
        FakeRequestHandler(resolver: (path, limit, offset) => throw Exception('down')),
      );

      final repo = ScheduleRepository(store: store);
      final result = await repo.getSchedule(forceRefresh: true);

      expect(result.fetchedFromNetwork, isFalse);
      expect(result.offlineFallback, isTrue);
      expect(result.schedule.raceTable.races.first.raceName, 'Bahrain Grand Prix');
    });
  });
}
