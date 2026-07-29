// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/widgets/tables/table_parts/tournament_table_drivers_detail_row.dart';
import 'package:f1_pet_project/common/widgets/tables/table_parts/tournament_table_drivers_primary_row.dart';
import 'package:f1_pet_project/common/widgets/tables/tappable_driver_row.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

/// Таблица зачёта пилотов текущего сезона.
class TournamentDriversTable extends StatelessWidget {
  const TournamentDriversTable({required this.drivers, this.passCurrentRoster = false, super.key});

  final List<DriverStandingsModel> drivers;

  /// Передавать команды из standings как «текущие» на карточку пилота (только Home).
  final bool passCurrentRoster;

  @override
  Widget build(BuildContext context) {
    final semanticsRows = [
      for (var i = 0; i < drivers.length; i++)
        '${context.l10n.driver}: ${drivers[i].driver.givenName} ${drivers[i].driver.familyName}. ' +
            '${context.l10n.nationality}: ${drivers[i].driver.nationality}. ' +
            '${context.l10n.points}: ${drivers[i].points}. ' +
            '${context.l10n.wins}: ${drivers[i].wins}. ' +
            '${context.l10n.constructor}: ${drivers[i].constructors.first.name}',
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Visibility(
          visible: false,
          maintainState: true,
          maintainAnimation: true,
          maintainSemantics: true,
          maintainSize: true,
          child: Column(
            children: [
              for (var i = 0; i < drivers.length; i++)
                Semantics(
                  button: true,
                  label: semanticsRows[i],
                  onTap: () => context.router.push(
                    DriverRoute(
                      driver: drivers[i].driver,
                      currentConstructors: passCurrentRoster ? drivers[i].constructors : const [],
                    ),
                  ),
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
                  columnWidths: const {
                    0: FixedColumnWidth(32),
                    1: FlexColumnWidth(0.24),
                    2: FlexColumnWidth(0.11),
                    3: FlexColumnWidth(0.18),
                    4: FlexColumnWidth(0.08),
                    5: FlexColumnWidth(0.27),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    driversPrimaryRow(context.l10n),
                    ...List.generate(drivers.length, (i) {
                      final standing = drivers[i];
                      return TableRow(
                        decoration: BoxDecoration(
                          color: i.isOdd ? context.colors.grayBG : Colors.transparent,
                          border: Border(bottom: BorderSide(color: context.colors.strokeGray)),
                        ),
                        children: tappableDriverRowCells(
                          context: context,
                          driver: standing.driver,
                          currentConstructors: passCurrentRoster ? standing.constructors : const [],
                          children: tournamentTableDriversDetailRowChildren(standing, i + 1),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
