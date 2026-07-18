import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/tables/tappable_driver_row.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/race_info/components/qualification_table_detail_row.dart';
import 'package:flutter/material.dart';

/// Таблица результатов квалификации.
class QualificationTable extends StatelessWidget {
  const QualificationTable({required this.qualifyingResults, super.key});
  final List<QualifyingResultsModel> qualifyingResults;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            ...List.generate(qualifyingResults.length, (i) {
              final result = qualifyingResults[i];
              return TableRow(
                decoration: BoxDecoration(
                  color: i.isOdd ? AppTheme.grayBG : Colors.transparent,
                  border: const Border(bottom: BorderSide(color: AppTheme.strokeGray)),
                ),
                children: tappableDriverRowCells(
                  context: context,
                  driver: result.driver,
                  children: qualificationTableDetailRowChildren(result, i + 1),
                ),
              );
            }),
          ],
        ),
        const Divider(height: 2, thickness: 1, color: AppTheme.strokeGray),
      ],
    );
  }
}
