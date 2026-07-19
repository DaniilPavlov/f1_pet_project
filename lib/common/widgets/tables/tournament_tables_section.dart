import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/custom_switcher.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_constructors_table.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_drivers_table.dart';
import 'package:f1_pet_project/core/home/controllers/tournament_tables_section_controller/tournament_tables_section_controller.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_standings_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_standings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Секция турнирных таблиц с переключением пилоты/конструкторы.
class TournamentTablesSection extends StatelessWidget {
  const TournamentTablesSection({
    required this.driversStandings,
    required this.constructorsStandings,
    this.title,
    this.season,
    this.round,
    this.passCurrentRoster = false,
    super.key,
  });

  final List<DriverStandingsModel> driversStandings;
  final List<ConstructorStandingsModel> constructorsStandings;
  final String? title;
  final String? season;
  final String? round;

  /// Прокидывать текущий состав из standings на карточки (Home текущего сезона).
  final bool passCurrentRoster;

  @override
  Widget build(BuildContext context) {
    return Provider<TournamentTablesSectionController>(
      create: (_) => TournamentTablesSectionController(),
      child: Observer(
        builder: (context) {
          final controller = context.read<TournamentTablesSectionController>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null || season != null || round != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: StaticData.defaultVerticalPadding),
                      if (title != null) Text(title!, style: AppStyles.h1),
                      if (season != null || round != null) ...[
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (season != null) Text(context.l10n.seasonLabel(season!), style: AppStyles.h2),
                            if (round != null) Text(context.l10n.roundLabel(round!), style: AppStyles.h2),
                          ],
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              CustomSwitcher(
                firstTitle: context.l10n.drivers,
                secondTitle: context.l10n.constructors,
                onChanged: controller.changeActiveTable,
                activeValue: controller.activeTable,
              ),
              if (controller.activeTable == 0)
                TournamentDriversTable(
                  drivers: driversStandings,
                  passCurrentRoster: passCurrentRoster,
                )
              else
                TournamentConstructorsTable(
                  constructors: constructorsStandings,
                  driversStandings: driversStandings,
                  passCurrentRoster: passCurrentRoster,
                ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }
}
