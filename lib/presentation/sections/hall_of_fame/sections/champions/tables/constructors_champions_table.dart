import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/sections/champions/tables/table_parts/constructors_champions_table_detail_row.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ConstructorsChampionsTable extends StatelessWidget {
  const ConstructorsChampionsTable({
    required this.constructors,
    super.key,
  });
  final List<StandingsListsModel> constructors;

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
              constructors.length,
              (i) => TableRow(
                decoration: BoxDecoration(
                  color: i.isOdd ? AppTheme.grayBG : Colors.transparent,
                  border: const Border(
                    bottom: BorderSide(
                      color: AppTheme.strokeGray,
                    ),
                  ),
                ),
                children: constructorsChampionsTableDetailRowChildren(
                  constructors[constructors.length - i - 1],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
