import 'package:f1_pet_project/data/models/sections/home/current_drivers_standings/current_drivers_standings_model.dart';
import 'package:f1_pet_project/domain/help/help_functions.dart';

import 'package:f1_pet_project/presentation/sections/home/tournament_tables/widgets/table_parts/tournament_table_drivers_detail_row.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_tables/widgets/table_parts/tournament_table_drivers_primary_row.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentDriversTable extends StatefulWidget {
  final List<DriverStanding> drivers;
  const TournamentDriversTable({
    required this.drivers,
    super.key,
  });

  @override
  State<TournamentDriversTable> createState() => _TournamentDriversTableState();
}

class _TournamentDriversTableState extends State<TournamentDriversTable> {
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
      0: FixedColumnWidth(maxPositionWidth + padding),
      1: FixedColumnWidth(maxNameWidth + padding * 2),
      2: FixedColumnWidth(maxPointsWidth + padding * 1.25),
      3: FixedColumnWidth(maxConstructorWidth + padding * 2),
      4: FixedColumnWidth(maxNumberWidth + padding),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Table(
          columnWidths: columnWidths,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            driversPrimaryRow(),
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
                children: tournamentTableDriversDetailRowChildren(
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
        'Имя',
        AppStyles.caption,
      );

      final numberWidth = HelpFunctions.getTextWidth(
        'Номер',
        AppStyles.caption,
      );

      final pointsWidth = HelpFunctions.getTextWidth(
        'Очки',
        AppStyles.caption,
      );

      final positionWidth = HelpFunctions.getTextWidth(
        'Позиция',
        AppStyles.caption,
      );

      final constructorWidth = HelpFunctions.getTextWidth(
        item.constructors[0].name,
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

      if (positionWidth > maxPositionWidth) {
        maxPositionWidth = positionWidth;
      }

      if (constructorWidth > maxConstructorWidth) {
        maxConstructorWidth = constructorWidth;
      }
    }
  }
}
