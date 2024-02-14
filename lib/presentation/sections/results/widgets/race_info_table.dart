import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/presentation/sections/results/widgets/table_parts/race_table_detail_row.dart';
import 'package:f1_pet_project/presentation/sections/results/widgets/table_parts/race_table_primary_row.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RaceInfoTable extends StatelessWidget {
  const RaceInfoTable({
    required this.raceModel,
    required this.fastestLap,
    this.rowsNumber,
    this.withPrimaryRow = true,
    super.key,
  });
  final RacesModel raceModel;
  final int? rowsNumber;
  final bool withPrimaryRow;
  final String fastestLap;

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
              rowsNumber ?? raceModel.results!.length,
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
                  raceModel.results![i],
                  fastestLap,
                  i + 1,
                ),
              ),
            ),
          ],
        ),
        if (rowsNumber != null)
          GestureDetector(
            onTap: () async =>
                context.router.navigate(RaceInfoRoute(raceModel: raceModel)),
            child: const ColoredBox(
              color: AppTheme.grayBG,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Подробная информация',
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
