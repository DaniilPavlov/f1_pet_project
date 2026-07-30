import 'package:f1_pet_project/core/results/season_rewind/components/season_rewind_racing_chart.dart';
import 'package:f1_pet_project/core/results/season_rewind/models/season_rewind_bar_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('SeasonRewindRacingChart renders labels and points', (tester) async {
    await tester.pumpApp(
      SeasonRewindRacingChart(
        entries: const [
          SeasonRewindBarEntry(
            id: 'max_verstappen',
            constructorId: 'red_bull',
            label: 'Verstappen',
            tag: 'VER',
            points: 100,
            rank: 0,
          ),
          SeasonRewindBarEntry(
            id: 'charles_leclerc',
            constructorId: 'ferrari',
            label: 'Leclerc',
            tag: 'LEC',
            points: 80,
            rank: 1,
          ),
        ],
      ),
    );

    expect(find.text('Verstappen'), findsOneWidget);
    expect(find.text('Leclerc'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('80'), findsOneWidget);
  });

  testWidgets('SeasonRewindRacingChart keeps identities while points change', (tester) async {
    await tester.pumpApp(
      const _ChartHost(
        first: [
          SeasonRewindBarEntry(
            id: 'a',
            constructorId: 'mercedes',
            label: 'Alpha',
            tag: 'A',
            points: 50,
            rank: 0,
          ),
          SeasonRewindBarEntry(
            id: 'b',
            constructorId: 'mclaren',
            label: 'Bravo',
            tag: 'B',
            points: 40,
            rank: 1,
          ),
        ],
        second: [
          SeasonRewindBarEntry(
            id: 'b',
            constructorId: 'mclaren',
            label: 'Bravo',
            tag: 'B',
            points: 90,
            rank: 0,
          ),
          SeasonRewindBarEntry(
            id: 'a',
            constructorId: 'mercedes',
            label: 'Alpha',
            tag: 'A',
            points: 60,
            rank: 1,
          ),
        ],
      ),
    );

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Bravo'), findsOneWidget);

    await tester.tap(find.text('swap'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Bravo'), findsOneWidget);
    expect(find.text('90'), findsOneWidget);
    expect(find.text('60'), findsOneWidget);
  });
}

class _ChartHost extends StatefulWidget {
  const _ChartHost({required this.first, required this.second});

  final List<SeasonRewindBarEntry> first;
  final List<SeasonRewindBarEntry> second;

  @override
  State<_ChartHost> createState() => _ChartHostState();
}

class _ChartHostState extends State<_ChartHost> {
  late List<SeasonRewindBarEntry> _entries = widget.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SeasonRewindRacingChart(entries: _entries),
        TextButton(
          onPressed: () => setState(() => _entries = widget.second),
          child: const Text('swap'),
        ),
      ],
    );
  }
}
