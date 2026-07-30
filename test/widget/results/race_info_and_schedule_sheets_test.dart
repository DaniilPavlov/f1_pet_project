import 'package:f1_pet_project/core/results/race_info/components/pit_stops_table.dart';
import 'package:f1_pet_project/core/results/race_info/components/qualification_table.dart';
import 'package:f1_pet_project/core/schedule/components/schedule_race_sessions_sheet.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('QualificationTable', () {
    testWidgets('renders qualifying rows', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: QualificationTable(qualifyingResults: ControllerFixtures.race.qualifyingResults!),
        ),
      );

      expect(find.textContaining('Verstappen'), findsOneWidget);
      expect(find.textContaining('1:10.000'), findsOneWidget);
    });
  });

  group('PitStopsTable', () {
    testWidgets('renders pit stop rows', (tester) async {
      await tester.pumpApp(
        SingleChildScrollView(
          child: PitStopsTable(pitStops: ControllerFixtures.race.pitStops!),
        ),
      );

      expect(find.textContaining('max_verstappen'), findsOneWidget);
      expect(find.textContaining('2.5'), findsOneWidget);
    });
  });

  group('ScheduleRaceSessionsSheet', () {
    testWidgets('lists practice and race sessions', (tester) async {
      final base = ControllerFixtures.race;
      final race = RacesModel(
        season: base.season,
        round: base.round,
        url: base.url,
        raceName: base.raceName,
        circuit: base.circuit,
        date: base.date,
        time: base.time,
        firstPractice: RaceDateModel(date: '2024-05-24', time: '12:00:00Z'),
        secondPractice: null,
        thirdPractice: null,
        qualifying: RaceDateModel(date: '2024-05-25', time: '14:00:00Z'),
        sprint: null,
        results: base.results,
        qualifyingResults: base.qualifyingResults,
        pitStops: base.pitStops,
      );

      await tester.pumpApp(
        SizedBox(height: 500, child: ScheduleRaceSessionsSheet(race: race)),
      );

      expect(find.text('Monaco Grand Prix'), findsOneWidget);
      expect(find.text('Monaco'), findsOneWidget);
    });
  });
}
