// ignore_for_file: prefer_adjacent_string_concatenation

import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/widgets/tables/table_parts/tournament_table_constructors_detail_row.dart';
import 'package:f1_pet_project/common/widgets/tables/table_parts/tournament_table_constructors_primary_row.dart';
import 'package:f1_pet_project/common/widgets/tables/tappable_constructor_row.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_standings_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
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
    final semanticsRows = [
      for (var i = 0; i < constructors.length; i++)
        '${context.l10n.constructor}: ${constructors[i].constructor.name}. ' +
            '${context.l10n.country}: ${constructors[i].constructor.nationality}. ' +
            '${context.l10n.points}: ${constructors[i].points}. ' +
            '${context.l10n.wins}: ${constructors[i].wins}',
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
              for (var i = 0; i < constructors.length; i++)
                Semantics(
                  button: true,
                  label: semanticsRows[i],
                  onTap: () => context.router.push(
                    ConstructorRoute(
                      constructor: constructors[i].constructor,
                      currentDrivers: passCurrentRoster
                          ? _currentDriversFor(constructors[i].constructor.constructorId)
                          : const [],
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
                    1: FlexColumnWidth(0.37),
                    2: FlexColumnWidth(0.16),
                    3: FlexColumnWidth(0.17),
                    4: FlexColumnWidth(0.15),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    constructorsPrimaryRow(context.l10n),
                    ...List.generate(constructors.length, (i) {
                      final standing = constructors[i];
                      return TableRow(
                        decoration: BoxDecoration(
                          color: i.isOdd ? context.colors.grayBG : Colors.transparent,
                          border: Border(bottom: BorderSide(color: context.colors.strokeGray)),
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
              ),
            ),
          ),
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
