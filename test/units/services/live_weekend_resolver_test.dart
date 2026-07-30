import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/controller_fixtures.dart';

void main() {
  group('LiveWeekendResolver', () {
    test('matches by circuit name from scoreboard', () {
      final race = ControllerFixtures.race;
      final event = EspnScoreboardEvent(
        name: 'Monaco GP',
        shortName: 'MON',
        statusState: 'in',
        statusDetail: 'Live',
        sessions: const [],
        circuitName: 'Monaco',
      );

      final resolved = LiveWeekendResolver.resolve(races: [race], scoreboard: event);

      expect(resolved, same(race));
    });

    test('falls back to weekend window containing now', () {
      final race = RacesModel(
        season: '2024',
        round: '5',
        url: 'http://example.com/race',
        raceName: 'Monaco Grand Prix',
        circuit: ControllerFixtures.circuit,
        date: '2024-05-26',
        time: '13:00:00Z',
        firstPractice: RaceDateModel(date: '2024-05-24', time: '12:00:00Z'),
        secondPractice: null,
        thirdPractice: null,
        qualifying: null,
        sprint: null,
        results: null,
        qualifyingResults: null,
        pitStops: null,
      );
      final now = DateTime.parse('2024-05-25T15:00:00Z').toLocal();

      final resolved = LiveWeekendResolver.resolve(races: [race], now: now);

      expect(resolved?.raceName, 'Monaco Grand Prix');
    });

    test('returns null when no circuit match and outside weekend', () {
      final race = ControllerFixtures.race;
      final now = DateTime.parse('2030-01-01T12:00:00Z').toLocal();

      final resolved = LiveWeekendResolver.resolve(races: [race], now: now);

      expect(resolved, isNull);
    });
  });

  group('f1pet://race/live uri', () {
    test('parses host race and path live', () {
      final uri = Uri.parse('f1pet://race/live');
      expect(uri.scheme, 'f1pet');
      expect(uri.host, 'race');
      expect(uri.pathSegments, ['live']);
    });
  });
}
