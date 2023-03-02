import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/results/results_model.dart';
import 'package:f1_pet_project/presentation/sections/results/sections/last_race_table/table_parts/race_table_detail_row.dart';
import 'package:f1_pet_project/presentation/sections/results/sections/last_race_table/table_parts/race_table_primary_row.dart';
import 'package:f1_pet_project/router/router.gr.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class LastRaceTable extends StatelessWidget {
  final List<ResultsModel> results;
  final int? rowsNumber;
  final bool withPrimaryRow;
  const LastRaceTable({
    required this.results,
    this.rowsNumber,
    this.withPrimaryRow = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            if (withPrimaryRow) raceTablePrimaryRow(),
            ...List.generate(
              rowsNumber ?? results.length,
              (i) => TableRow(
                decoration: BoxDecoration(
                  color: i.isOdd ? AppTheme.grayBG : Colors.transparent,
                  border: const Border(
                    bottom: BorderSide(
                      color: AppTheme.strokeGray,
                    ),
                  ),
                ),
                children: raceTableDetailRowChildren(
                  results[i],
                  i + 1,
                ),
              ),
            ),
          ],
        ),
        if (rowsNumber != null)
          GestureDetector(
            onTap: () async =>
                context.router.navigate(LastRaceRoute(results: results)),
            child: ColoredBox(
              color: AppTheme.grayBG,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Полная таблица',
                      style: AppStyles.caption,
                    ),
                  ),
                  Icon(Icons.arrow_right_alt),
                ],
              ),
            ),
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
