import 'package:f1_pet_project/data/models/sections/home/current_constructors_standing/current_constractors_standings_model.dart';
import 'package:f1_pet_project/domain/help/help_functions.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_tables/widgets/table_parts/tournament_table_constructors_detail_row.dart';
import 'package:f1_pet_project/presentation/sections/home/tournament_tables/widgets/table_parts/tournament_table_constructors_primary_row.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class TournamentConstructorsTable extends StatefulWidget {
  final List<ConstructorStanding> constructors;
  const TournamentConstructorsTable({
    required this.constructors,
    super.key,
  });

  @override
  State<TournamentConstructorsTable> createState() =>
      _TournamentConstructorsTableState();
}

class _TournamentConstructorsTableState
    extends State<TournamentConstructorsTable> {
  double maxNationalityWidth = 0;
  double maxWinsWidth = 0;
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
      1: FixedColumnWidth(maxConstructorWidth + padding),
      2: FixedColumnWidth(maxPointsWidth + padding),
      3: FixedColumnWidth(maxWinsWidth + padding),
      4: FixedColumnWidth(maxNationalityWidth + padding * 2),
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Table(
          columnWidths: columnWidths,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            constructorsPrimaryRow(),
            ...List.generate(
              widget.constructors.length,
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
                  widget.constructors[i],
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
    for (final item in widget.constructors) {
      final nationalityWidth = HelpFunctions.getTextWidth(
        item.constructor.nationality,
        AppStyles.caption,
      );

      final winsWidth = HelpFunctions.getTextWidth(
        'Победы',
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
        item.constructor.name,
        AppStyles.caption,
      );

      if (nationalityWidth > maxNationalityWidth) {
        maxNationalityWidth = nationalityWidth;
      }

      if (winsWidth > maxWinsWidth) {
        maxWinsWidth = winsWidth;
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
