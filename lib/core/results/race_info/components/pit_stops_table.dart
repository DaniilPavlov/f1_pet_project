import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
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
                  color: i.isOdd ? AppTheme.grayBG : Colors.transparent,
                  border: const Border(bottom: BorderSide(color: AppTheme.strokeGray)),
                ),
                children: pitStopsTableDetailRowChildren(pitStops[i], i + 1),
              ),
            ),
          ],
        ),
        const Divider(height: 2, thickness: 1, color: AppTheme.strokeGray),
      ],
    );
  }
}
