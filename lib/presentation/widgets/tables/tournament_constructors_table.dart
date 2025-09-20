import 'package:f1_pet_project/data/models/sections/home/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/presentation/widgets/tables/table_parts/tournament_table_constructors_detail_row.dart';
import 'package:f1_pet_project/presentation/widgets/tables/table_parts/tournament_table_constructors_primary_row.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TournamentConstructorsTable extends StatelessWidget {
  const TournamentConstructorsTable({
    required this.constructors,
    super.key,
  });
  final List<ConstructorStandingsModel> constructors;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Table(
          columnWidths: const {
            0: FractionColumnWidth(0.05),
            1: FlexColumnWidth(0.3),
            2: FlexColumnWidth(0.3),
            3: FlexColumnWidth(0.2),
            4: FlexColumnWidth(0.15),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            constructorsPrimaryRow(),
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
                children: tournamentTableConstructorsDetailRowChildren(
                  constructors[i],
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
