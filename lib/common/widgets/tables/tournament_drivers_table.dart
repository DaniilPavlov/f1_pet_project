import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/tables/table_parts/tournament_table_drivers_detail_row.dart';
import 'package:f1_pet_project/common/widgets/tables/table_parts/tournament_table_drivers_primary_row.dart';
import 'package:f1_pet_project/common/widgets/tables/tappable_driver_row.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_standings_model.dart';
import 'package:flutter/material.dart';

/// Таблица зачёта пилотов текущего сезона.
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
            0: FractionColumnWidth(0.05),
            1: FlexColumnWidth(0.2),
            2: FlexColumnWidth(0.3),
            3: FlexColumnWidth(0.1),
            4: FlexColumnWidth(0.1),
            5: FlexColumnWidth(0.25),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            driversPrimaryRow(),
            ...List.generate(
              drivers.length,
              (i) {
                final standing = drivers[i];
                return TableRow(
                  decoration: BoxDecoration(
                    color: i.isOdd ? AppTheme.grayBG : Colors.transparent,
                    border: const Border(
                      bottom: BorderSide(
                        color: AppTheme.strokeGray,
                      ),
                    ),
                  ),
                  children: tappableDriverRowCells(
                    context: context,
                    driver: standing.driver,
                    children: tournamentTableDriversDetailRowChildren(standing, i + 1),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
