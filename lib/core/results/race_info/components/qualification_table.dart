// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constructor_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/widgets/tables/tappable_driver_row.dart';
import 'package:f1_pet_project/core/results/models/qualifying_results_model.dart';
import 'package:f1_pet_project/core/results/race_info/components/qualification_table_detail_row.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

/// Таблица результатов квалификации.
class QualificationTable extends StatelessWidget {
  const QualificationTable({required this.qualifyingResults, super.key});
  final List<QualifyingResultsModel> qualifyingResults;

  @override
  Widget build(BuildContext context) {
    final semanticsRows = [
      for (var i = 0; i < qualifyingResults.length; i++)
        '${context.l10n.qualifying}. ${context.l10n.round} ${i + 1}. ' +
            '${context.l10n.driver}: ${qualifyingResults[i].driver.givenName} ${qualifyingResults[i].driver.familyName}. ' +
            '${context.l10n.constructor}: ${qualifyingResults[i].constructor.name}. ' +
            'Q1: ${qualifyingResults[i].q1}. ' +
            'Q2: ${qualifyingResults[i].q2 ?? '-'}. ' +
            'Q3: ${qualifyingResults[i].q3 ?? '-'}',
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
              for (var i = 0; i < qualifyingResults.length; i++)
                Semantics(
                  button: true,
                  label: semanticsRows[i],
                  onTap: () => context.router.push(DriverRoute(driver: qualifyingResults[i].driver)),
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
                  children: [
                    ...List.generate(qualifyingResults.length, (i) {
                      final result = qualifyingResults[i];
                      return TableRow(
                        decoration: ConstructorColors.tableRowDecoration(
                          zebraColor: context.colors.grayBG,
                          bottomBorderColor: context.colors.strokeGray,
                          index: i,
                          constructorId: result.constructor.constructorId,
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
              ),
            ),
          ),
        ),
        Divider(height: 2, thickness: 1, color: context.colors.strokeGray),
      ],
    );
  }
}
