import 'package:f1_pet_project/data/models/sections/results/pit_stops_model.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/widgets/pit_stops_table/table_parts/pit_stops_table_detail_row.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class PitStopsTable extends StatelessWidget {
  final List<PitStopsModel> pitStops;

  const PitStopsTable({required this.pitStops, super.key});

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
                  border: const Border(
                    bottom: BorderSide(
                      color: AppTheme.strokeGray,
                    ),
                  ),
                ),
                children: pitStopsTableDetailRowChildren(
                  pitStops[i],
                  i + 1,
                ),
              ),
            ),
          ],
        ),
        const Divider(
          height: 2,
          thickness: 1,
          color: AppTheme.strokeGray,
        ),
      ],
    );
  }
}
