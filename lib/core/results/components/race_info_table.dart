// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/tables/tappable_driver_row.dart';
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
    final semanticsRows = [
      for (final result in rows)
        '${context.l10n.driver}: ${result.driver.givenName} ${result.driver.familyName}. ' +
            '${context.l10n.constructor}: ${result.constructor.name}. ' +
            '${context.l10n.time}: ${result.displayTimeOrStatus}. ' +
            '${context.l10n.points}: ${result.points}. ' +
            '${context.l10n.bestLap}: ' +
            // ignore: unnecessary_string_interpolations
            '${result.fastestLap == null ? context.l10n.none : result.fastestLap!.time.time}',
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible: false,
          maintainState: true,
          maintainAnimation: true,
          maintainSemantics: true,
          maintainSize: true,
          child: Column(
            children: [
              for (var i = 0; i < (rowsNumber ?? rows.length); i++)
                Semantics(
                  button: true,
                  label: semanticsRows[i],
                  onTap: () => context.router.push(DriverRoute(driver: rows[i].driver)),
                  child: const SizedBox.shrink(),
                ),
            ],
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
                  columnWidths: const {
                    0: FlexColumnWidth(1.1),
                    1: FlexColumnWidth(1.35),
                    2: FlexColumnWidth(1.15),
                    3: FlexColumnWidth(0.55),
                    4: FlexColumnWidth(0.85),
                  },
                  children: [
                    if (withPrimaryRow) raceTablePrimaryRow(context.l10n),
                    ...List.generate(rowsNumber ?? rows.length, (i) {
                      final result = rows[i];
                      return TableRow(
                        decoration: BoxDecoration(
                          color: i.isOdd ? context.colors.grayBG : Colors.transparent,
                          border: Border(bottom: BorderSide(color: context.colors.strokeGray)),
                        ),
                        children: tappableDriverRowCells(
                          context: context,
                          driver: result.driver,
                          children: raceTableDetailRowChildren(result, fastest, context.l10n),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (rowsNumber != null)
          GestureDetector(
            onTap: () async => context.router.navigate(RaceInfoRoute(raceModel: raceModel)),
            child: ColoredBox(
              color: context.colors.grayBG,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(context.l10n.detailedInfo, style: AppStyles.caption),
                  ),
                  Icon(Icons.arrow_right_alt),
                ],
              ),
            ),
          ),
        Divider(height: 2, thickness: 1, color: context.colors.strokeGray),
      ],
    );
  }
}
