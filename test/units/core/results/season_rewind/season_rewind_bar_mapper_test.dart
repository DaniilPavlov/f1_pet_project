import 'package:f1_pet_project/core/results/season_rewind/models/season_rewind_bar_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/controller_fixtures.dart';

void main() {
  group('SeasonRewindBarMapper', () {
    test('maps all drivers sorted by points', () {
      final standings =
          ControllerFixtures.driversStandingsModel.standingsTable.standingsLists.first.driverStandings!;
      final entries = SeasonRewindBarMapper.fromDrivers(standings);

      expect(entries.length, standings.length);
      expect(entries.first.rank, 0);
      expect(entries.first.label, isNotEmpty);
      expect(entries.first.constructorId, isNotEmpty);
      for (var i = 1; i < entries.length; i++) {
        expect(entries[i].points, lessThanOrEqualTo(entries[i - 1].points));
        expect(entries[i].rank, i.toDouble());
      }
    });

    test('maps all constructors', () {
      final standings = ControllerFixtures
          .constructorsStandingsModel
          .standingsTable
          .standingsLists
          .first
          .constructorStandings!;
      final entries = SeasonRewindBarMapper.fromConstructors(standings);

      expect(entries.length, standings.length);
      expect(entries.first.id, isNotEmpty);
      expect(entries.first.label, isNotEmpty);
      expect(entries.first.constructorId, entries.first.id);
    });
  });
}
