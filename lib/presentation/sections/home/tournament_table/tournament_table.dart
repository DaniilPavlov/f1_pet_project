import 'package:f1_pet_project/data/models/sections/home/current_drivers_standings/current_drivers_standings_model.dart';
import 'package:f1_pet_project/domain/help/help_functions.dart';

import 'package:f1_pet_project/presentation/sections/home/tournament_table/table_parts/tournament_table_detail_row.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_table/table_parts/tournament_table_primary_row.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentTable extends StatefulWidget {
  final List<DriverStanding> drivers;
  const TournamentTable({
    required this.drivers,
    super.key,
  });

  @override
  State<TournamentTable> createState() => _TournamentTableState();
}

class _TournamentTableState extends State<TournamentTable> {
  double maxNameWidth = 0;
  double maxNumberWidth = 0;
  double maxPointsWidth = 0;
  double maxPositionWidth = 0;
  double maxConstructorWidth = 0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const padding = 20.0;
    final columnWidths = <int, TableColumnWidth>{
      0: const FixedColumnWidth(60),
      1: FixedColumnWidth(maxNameWidth + padding),
      2: const FixedColumnWidth(60),
      3: FixedColumnWidth(maxPointsWidth + padding),
      // 4: FixedColumnWidth(maxPositionWidth + padding),
      5: FixedColumnWidth(maxConstructorWidth + padding),
    };

    return Column(
      children: [
        const SizedBox(height: 8),
        Table(
          columnWidths: columnWidths,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            primaryRow(),
            ...List.generate(
              widget.drivers.length,
              (i) => TableRow(
                decoration: BoxDecoration(
                  color: i.isOdd ? AppTheme.grayBG : Colors.transparent,
                  border: const Border(
                    bottom: BorderSide(
                      color: AppTheme.strokeGray,
                    ),
                  ),
                ),
                children: tournamentTableDetailRowChildren(
                  widget.drivers[i],
                  i + 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _init() {
    for (final item in widget.drivers) {
      final nameWidth = HelpFunctions.getTextWidth(
        item.driver.code.toString(),
        AppStyles.caption,
      );

      final numberWidth = HelpFunctions.getTextWidth(
        item.driver.permanentNumber.toString(),
        AppStyles.caption,
      );

      final pointsWidth = HelpFunctions.getTextWidth(
        item.points.toString(),
        AppStyles.caption,
      );

      // final positionWidth = HelpFunctions.getTextWidth(
      //   item.position.toString(),
      //   AppStyles.caption,
      // );

      final constructorWidth = HelpFunctions.getTextWidth(
        item.position.toString(),
        AppStyles.caption,
      );

      if (nameWidth > maxNameWidth) {
        maxNameWidth = nameWidth;
      }

      if (numberWidth > maxNumberWidth) {
        maxNumberWidth = numberWidth;
      }

      if (pointsWidth > maxPointsWidth) {
        maxPointsWidth = pointsWidth;
      }

      // if (positionWidth > maxPositionWidth) {
      //   maxPositionWidth = positionWidth;
      // }

      if (constructorWidth > maxConstructorWidth) {
        maxConstructorWidth = constructorWidth;
      }
    }
  }
}
