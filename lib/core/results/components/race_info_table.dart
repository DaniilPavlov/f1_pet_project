import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/results/components/race_table_detail_row.dart';
import 'package:f1_pet_project/core/results/components/race_table_primary_row.dart';
import 'package:f1_pet_project/core/results/models/results_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

/// Таблица результатов гонки/спринта с опциональным ограничением числа строк.
class RaceInfoTable extends StatelessWidget {
  const RaceInfoTable({
    required this.raceModel,
    this.results,
    this.fastestLapTime,
    this.rowsNumber,
    this.withPrimaryRow = true,
    super.key,
  });
  final RacesModel raceModel;
  final List<ResultsModel>? results;
  final String? fastestLapTime;
  final int? rowsNumber;
  final bool withPrimaryRow;

  @override
  Widget build(BuildContext context) {
    final rows = results ?? raceModel.results ?? const <ResultsModel>[];
    final fastest = fastestLapTime ?? RacesModel.fastestLapAmong(rows);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            if (withPrimaryRow) raceTablePrimaryRow(),
            ...List.generate(
              rowsNumber ?? rows.length,
              (i) => TableRow(
                decoration: BoxDecoration(
                  color: i.isOdd ? AppTheme.grayBG : Colors.transparent,
                  border: const Border(bottom: BorderSide(color: AppTheme.strokeGray)),
                ),
                children: raceTableDetailRowChildren(rows[i], fastest, i + 1),
              ),
            ),
          ],
        ),
        if (rowsNumber != null)
          GestureDetector(
            onTap: () async => context.router.navigate(RaceInfoRoute(raceModel: raceModel)),
            child: const ColoredBox(
              color: AppTheme.grayBG,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Подробная информация', style: AppStyles.caption),
                  ),
                  Icon(Icons.arrow_right_alt),
                ],
              ),
            ),
          ),
        const Divider(height: 2, thickness: 1, color: AppTheme.strokeGray),
      ],
    );
  }
}
