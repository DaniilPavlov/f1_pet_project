import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';

void main() {
  group('RaceDateTimeHelper', () {
    test('toLocal parses Z and empty time as midnight UTC', () {
      final withZ = RaceDateTimeHelper.toLocal(RaceDateModel(date: '2024-05-26', time: '13:00:00Z'));
      expect(withZ.isUtc, isFalse);
      expect(withZ.toUtc().hour, 13);

      final midnight = RaceDateTimeHelper.toLocal(RaceDateModel(date: '2024-05-26', time: ''));
      expect(midnight.toUtc(), DateTime.utc(2024, 5, 26));
    });

    test('isUpcoming / raceLocal use race start', () {
      final race = ControllerFixtures.race; // 2024-05-26 13:00Z
      expect(RaceDateTimeHelper.isUpcoming(race, DateTime.utc(2024, 5, 1)), isTrue);
      expect(RaceDateTimeHelper.isUpcoming(race, DateTime.utc(2024, 6, 1)), isFalse);
      expect(RaceDateTimeHelper.raceLocal(race).toUtc(), DateTime.utc(2024, 5, 26, 13));
    });

    test('countdownTarget prefers first practice when present', () {
      final race = ControllerFixtures.race;
      // fixtures have null practices → falls back to race
      expect(
        RaceDateTimeHelper.countdownTarget(race).toUtc(),
        DateTime.utc(2024, 5, 26, 13),
      );
      expect(
        RaceDateTimeHelper.weekendStart(race).toUtc(),
        DateTime.utc(2024, 5, 26, 13),
      );
    });
  });

  group('CountdownParts', () {
    test('until builds parts and zero for past targets', () {
      final parts = CountdownParts.until(
        DateTime(2026, 1, 3, 5, 10, 15),
        DateTime(2026, 1, 1, 2, 0, 0),
      );
      expect(parts.days, 2);
      expect(parts.hours, 3);
      expect(parts.minutes, 10);
      expect(parts.seconds, 15);
      expect(parts.isZero, isFalse);

      expect(CountdownParts.until(DateTime(2020), DateTime(2021)).isZero, isTrue);
    });
  });
}
