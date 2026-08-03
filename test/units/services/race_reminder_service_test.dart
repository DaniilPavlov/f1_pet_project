import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/l10n/app_localizations_en.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/controller_fixtures.dart';

void main() {
  group('RaceReminderService.parseTapPayload', () {
    test('accepts race season/round deep link', () {
      final uri = RaceReminderService.parseTapPayload('f1pet://race/2026/12');
      expect(uri?.host, 'race');
      expect(uri?.pathSegments, ['2026', '12']);
    });

    test('accepts race/live deep link', () {
      expect(RaceReminderService.parseTapPayload('f1pet://race/live')?.pathSegments, ['live']);
    });

    test('rejects empty, legacy name, and foreign schemes', () {
      expect(RaceReminderService.parseTapPayload(null), isNull);
      expect(RaceReminderService.parseTapPayload(''), isNull);
      expect(RaceReminderService.parseTapPayload('Monaco Grand Prix'), isNull);
      expect(RaceReminderService.parseTapPayload('https://example.com'), isNull);
      expect(RaceReminderService.parseTapPayload('f1pet://driver/hamilton'), isNull);
    });
  });

  group('RaceReminderService.sessionEntries', () {
    final l10n = AppLocalizationsEn();
    final base = ControllerFixtures.race;
    final race = RacesModel(
      season: base.season,
      round: base.round,
      url: base.url,
      raceName: base.raceName,
      circuit: base.circuit,
      date: '2099-01-04',
      time: '14:00:00Z',
      firstPractice: RaceDateModel(date: '2099-01-01', time: '10:00:00Z'),
      secondPractice: RaceDateModel(date: '2099-01-01', time: '14:00:00Z'),
      thirdPractice: RaceDateModel(date: '2099-01-02', time: '10:00:00Z'),
      qualifying: RaceDateModel(date: '2099-01-03', time: '14:00:00Z'),
      sprint: null,
      results: base.results,
      qualifyingResults: base.qualifyingResults,
      pitStops: base.pitStops,
    );

    test('includes practices when includePractices is true', () {
      final keys = RaceReminderService.sessionEntries(race, l10n, includePractices: true)
          .map((e) => e.$1)
          .toList();
      expect(keys, containsAll(['fp1', 'fp2', 'fp3', 'quali', 'race']));
    });

    test('skips practices when includePractices is false', () {
      final keys = RaceReminderService.sessionEntries(race, l10n, includePractices: false)
          .map((e) => e.$1)
          .toList();
      expect(keys, isNot(contains('fp1')));
      expect(keys, isNot(contains('fp2')));
      expect(keys, isNot(contains('fp3')));
      expect(keys, containsAll(['quali', 'race']));
    });
  });

  group('RaceReminderService.buildPlannedReminders', () {
    final l10n = AppLocalizationsEn();

    test('skips sessions whose notify time is in the past', () {
      final base = ControllerFixtures.race;
      final race = RacesModel(
        season: '2026',
        round: '1',
        url: base.url,
        raceName: 'Past GP',
        circuit: base.circuit,
        date: '2020-01-04',
        time: '14:00:00Z',
        firstPractice: null,
        secondPractice: null,
        thirdPractice: null,
        qualifying: RaceDateModel(date: '2020-01-03', time: '14:00:00Z'),
        sprint: null,
        results: const [],
        qualifyingResults: const [],
        pitStops: const [],
      );

      final planned = RaceReminderService.buildPlannedReminders(
        [race],
        l10n,
        includePractices: true,
        now: DateTime.utc(2026, 1, 1),
      );
      expect(planned, isEmpty);
    });

    test('keeps future sessions sorted and stable ids', () {
      final base = ControllerFixtures.race;
      final race = RacesModel(
        season: '2026',
        round: '12',
        url: base.url,
        raceName: 'Future GP',
        circuit: base.circuit,
        date: '2099-06-02',
        time: '14:00:00Z',
        firstPractice: null,
        secondPractice: null,
        thirdPractice: null,
        qualifying: RaceDateModel(date: '2099-06-01', time: '14:00:00Z'),
        sprint: RaceDateModel(date: '2099-06-01', time: '10:00:00Z'),
        results: const [],
        qualifyingResults: const [],
        pitStops: const [],
      );

      final planned = RaceReminderService.buildPlannedReminders(
        [race],
        l10n,
        includePractices: false,
        now: DateTime.utc(2026, 1, 1),
      );
      expect(planned.length, 3);
      expect(planned.map((e) => e.notifyAt).toList(), orderedEquals([...planned.map((e) => e.notifyAt)]..sort()));
      expect(
        planned.map((e) => e.id).toSet(),
        {
          RaceReminderService.notificationId('2026', '12', 'sprint'),
          RaceReminderService.notificationId('2026', '12', 'quali'),
          RaceReminderService.notificationId('2026', '12', 'race'),
        },
      );
    });
  });
}
