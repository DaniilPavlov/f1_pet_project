import 'package:f1_pet_project/data/models/sections/home/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/tables/table_parts/tournament_table_drivers_detail_row.dart';
import 'package:f1_pet_project/presentation/sections/home/sections/tournament_tables/tables/table_parts/tournament_table_drivers_primary_row.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TournamentDriversTable extends StatelessWidget {
  const TournamentDriversTable({
    required this.drivers,
    super.key,
  });
  final List<DriverStandingsModel> drivers;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Table(
          columnWidths: const {
            0: FractionColumnWidth(0.1),
            1: FlexColumnWidth(0.2),
            2: FlexColumnWidth(0.25),
            3: FlexColumnWidth(0.1),
            4: FlexColumnWidth(0.35),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            driversPrimaryRow(),
            ...List.generate(
              drivers.length,
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
                  drivers[i],
                  i + 1,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
