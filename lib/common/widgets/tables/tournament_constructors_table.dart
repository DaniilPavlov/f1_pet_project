import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/tables/table_parts/tournament_table_constructors_detail_row.dart';
import 'package:f1_pet_project/common/widgets/tables/table_parts/tournament_table_constructors_primary_row.dart';
import 'package:f1_pet_project/common/widgets/tables/tappable_constructor_row.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:flutter/material.dart';

/// Таблица зачёта конструкторов текущего сезона.
class TournamentConstructorsTable extends StatelessWidget {
  const TournamentConstructorsTable({
    required this.constructors,
    this.driversStandings = const [],
    this.passCurrentRoster = false,
    super.key,
  });

  final List<ConstructorStandingsModel> constructors;
  final List<DriverStandingsModel> driversStandings;

  /// Передавать пилотов из standings как «текущих» на карточку команды (только Home).
  final bool passCurrentRoster;

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
            constructorsPrimaryRow(context.l10n),
            ...List.generate(constructors.length, (i) {
              final standing = constructors[i];
              return TableRow(
                decoration: BoxDecoration(
                  color: i.isOdd ? AppTheme.grayBG : Colors.transparent,
                  border: const Border(bottom: BorderSide(color: AppTheme.strokeGray)),
                ),
                children: tappableConstructorRowCells(
                  context: context,
                  constructor: standing.constructor,
                  currentDrivers: passCurrentRoster
                      ? _currentDriversFor(standing.constructor.constructorId)
                      : const [],
                  children: tournamentTableConstructorsDetailRowChildren(standing, i + 1),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  List<DriverModel> _currentDriversFor(String constructorId) {
    return [
      for (final standing in driversStandings)
        if (standing.constructors.any((c) => c.constructorId == constructorId)) standing.driver,
    ];
  }
}
