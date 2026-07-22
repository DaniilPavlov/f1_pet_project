import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/tournament_tables_shimmer.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_tables_section.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_field.dart';
import 'package:f1_pet_project/core/hall_of_fame/controllers/hall_of_fame_screen_controller/hall_of_fame_screen_controller.dart';
import 'package:f1_pet_project/core/hall_of_fame/repositories/season_standings_repository.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран «Зал славы» с турнирными таблицами за выбранный сезон.
@RoutePage()
class HallOfFameScreen extends StatelessWidget {
  const HallOfFameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<HallOfFameScreenController>(
      create: (context) => HallOfFameScreenController(
        seasonsRepository: context.read<SeasonsRepository>(),
        standingsRepository: context.read<SeasonStandingsRepository>(),
        dataRefresh: context.read<AppDataRefresh>(),
      )..bootstrap(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.hallOfFameTitle, onPop: context.router.removeLast),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<HallOfFameScreenController>();
              final isLoading =
                  controller.driversStandings.isLoading || controller.constructorsStandings.isLoading;
              if (controller.screenError != null && !isLoading) {
                return ErrorBody(
                  onTap: controller.refreshAll,
                  title: controller.screenError!.title,
                  subtitle: controller.screenError!.subtitle,
                );
              }

              final constructors = controller.constructorsStandings.value;
              final drivers = controller.driversStandings.value;

              return RefreshIndicator(
                color: AppTheme.red,
                onRefresh: controller.refreshAll,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollBehavior: AntiGlowBehavior(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: StaticData.defaultHorizontalPadding,
                          right: StaticData.defaultHorizontalPadding,
                          top: StaticData.defaultVerticalPadding,
                          bottom: StaticData.defaultVerticalPadding,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            child: SeasonPickerField(
                              controller: controller.yearController,
                              onChanged: controller.loadAllData,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isLoading)
                      const SliverToBoxAdapter(child: TournamentTablesShimmer(showHeader: false))
                    else if (constructors != null && drivers != null)
                      SliverToBoxAdapter(
                        child: TournamentTablesSection(
                          driversStandings: drivers[0].driverStandings!,
                          constructorsStandings: constructors[0].constructorStandings!,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
