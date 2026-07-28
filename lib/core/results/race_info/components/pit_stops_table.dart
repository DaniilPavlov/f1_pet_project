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
    return Column(
      children: [
        Table(
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
        Divider(height: 2, thickness: 1, color: context.colors.strokeGray),
      ],
    );
  }
}
