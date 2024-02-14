import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/sections/champions/tables/table_parts/drivers_champions_table_detail_row.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DriversChampionsTable extends StatelessWidget {
  const DriversChampionsTable({
    required this.drivers,
    super.key,
  });
  final List<StandingsListsModel> drivers;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
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
                children: driversChampionsTableDetailRowChildren(
                  drivers[drivers.length - i - 1],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
