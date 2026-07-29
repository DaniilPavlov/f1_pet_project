// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/core/results/models/pit_stops_model.dart';
import 'package:f1_pet_project/core/results/race_info/components/pit_stops_table_detail_row.dart';
import 'package:flutter/material.dart';

/// Таблица пит-стопов гонки.
class PitStopsTable extends StatelessWidget {
  const PitStopsTable({required this.pitStops, super.key});
  final List<PitStopsModel> pitStops;

  @override
  Widget build(BuildContext context) {
    final semanticsRows = [
      for (var i = 0; i < pitStops.length; i++)
        '${context.l10n.driver}: ${pitStops[i].driverId}. ' +
            '${context.l10n.lap}: ${pitStops[i].lap}. ' +
            '${context.l10n.stopNumber}: ${pitStops[i].stop}. ' +
            '${context.l10n.stopTime}: ${pitStops[i].duration}. ' +
            '${context.l10n.raceTime}: ${pitStops[i].time}',
    ];

    return Column(
      children: [
        Visibility(
          visible: false,
          maintainState: true,
          maintainAnimation: true,
          maintainSemantics: true,
          maintainSize: true,
          child: Column(
            children: [for (final row in semanticsRows) Semantics(label: row, child: const SizedBox.shrink())],
          ),
        ),
        ExcludeSemantics(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    ...List.generate(
                      pitStops.length,
                      (i) => TableRow(
                        decoration: BoxDecoration(
                          color: i.isOdd ? context.colors.grayBG : Colors.transparent,
                          border: Border(bottom: BorderSide(color: context.colors.strokeGray)),
                        ),
                        children: pitStopsTableDetailRowChildren(pitStops[i], i + 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(height: 2, thickness: 1, color: context.colors.strokeGray),
      ],
    );
  }
}
