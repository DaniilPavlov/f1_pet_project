import 'package:f1_pet_project/services/cache/prefs_json_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PrefsJsonStore', () {
    test('write then read round-trips data and cachedAt', () async {
      const store = PrefsJsonStore('test_prefs_json');
      final at = DateTime(2024, 5, 26, 12);

      await store.write({'a': 1, 'b': 'x'}, cachedAt: at);
      final loaded = await store.read();

      expect(loaded, isNotNull);
      expect(loaded!.data, {'a': 1, 'b': 'x'});
      expect(loaded.cachedAt, at.toLocal());
    });

    test('read returns null for missing / corrupt payload', () async {
      const store = PrefsJsonStore('missing_key');
      expect(await store.read(), isNull);

      SharedPreferences.setMockInitialValues({
        'bad': '{"data":"not-a-map","cachedAt":"2024-01-01"}',
      });
      expect(await const PrefsJsonStore('bad').read(), isNull);

      SharedPreferences.setMockInitialValues({'bad_json': 'not-json'});
      expect(await const PrefsJsonStore('bad_json').read(), isNull);
    });

    test('clear removes key', () async {
      const store = PrefsJsonStore('to_clear');
      await store.write({'k': true});
      await store.clear();
      expect(await store.read(), isNull);
    });
  });

  group('isSameCalendarDay', () {
    test('compares local calendar day', () {
      final now = DateTime(2024, 7, 29, 18);
      expect(isSameCalendarDay(DateTime(2024, 7, 29, 1), now: now), isTrue);
      expect(isSameCalendarDay(DateTime(2024, 7, 28, 23), now: now), isFalse);
      expect(isSameCalendarDay(null, now: now), isFalse);
    });
  });

  group('DayPrefsJsonStore', () {
    test('writeToday is readable via readToday and readAny', () async {
      const store = DayPrefsJsonStore(dataKey: 'day_data', dateKey: 'day_date');
      await store.writeToday({'score': 42});

      expect(await store.readToday(), {'score': 42});
      expect(await store.readAny(), {'score': 42});
    });

    test('readToday ignores stale date', () async {
      SharedPreferences.setMockInitialValues({
        'day_data': '{"score":1}',
        'day_date': '2000-01-01',
      });
      const store = DayPrefsJsonStore(dataKey: 'day_data', dateKey: 'day_date');

      expect(await store.readToday(), isNull);
      expect(await store.readAny(), {'score': 1});
    });

    test('clear removes both keys', () async {
      const store = DayPrefsJsonStore(dataKey: 'day_data', dateKey: 'day_date');
      await store.writeToday({'a': 1});
      await store.clear();
      expect(await store.readAny(), isNull);
      expect(await store.readToday(), isNull);
    });
  });
}
