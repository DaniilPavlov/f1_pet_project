import 'package:f1_pet_project/data/models/sections/results/qualifying_results_model.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/widgets/qualification_table/table_parts/qualification_table_detail_row.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

// TODO(check): check what sprints show
class QualificationTable extends StatelessWidget {
  const QualificationTable({
    required this.qualifyingResults,
    super.key,
  });
  final List<QualifyingResultsModel> qualifyingResults;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            ...List.generate(
              qualifyingResults.length,
              (i) => TableRow(
                decoration: BoxDecoration(
                  color: i.isOdd ? AppTheme.grayBG : Colors.transparent,
                  border: const Border(
                    bottom: BorderSide(
                      color: AppTheme.strokeGray,
                    ),
                  ),
                ),
                children: qualificationTableDetailRowChildren(
                  qualifyingResults[i],
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
