import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/tournament_tables_shimmer.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_tables_section.dart';
import 'package:f1_pet_project/core/home/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Главный экран с турнирными таблицами текущего сезона.
@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<HomeScreenController>(
      create: (context) => HomeScreenController(
        standingsRepository: context.read<CurrentStandingsRepository>(),
        dataRefresh: context.read<AppDataRefresh>(),
      )..loadAllData(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          // GoF Behavioral Observer — вид подписывается на MobX-observable
          // контроллера и перестраивается при изменении standings / ошибок.
          child: Observer(
            builder: (context) {
              final controller = context.read<HomeScreenController>();
              final hasData = controller.currentDrivers.value != null && controller.currentConstructors.value != null;
              if (!hasData && (controller.currentDrivers.isLoading || controller.currentConstructors.isLoading)) {
                return const SingleChildScrollView(child: TournamentTablesShimmer());
              }
              if (controller.screenError != null && !hasData) {
                return ErrorBody(
                  onTap: controller.refreshAll,
                  title: controller.screenError!.title,
                  subtitle: controller.screenError!.subtitle,
                );
              }

              return RefreshIndicator(
                color: AppTheme.red,
                onRefresh: controller.refreshAll,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollBehavior: AntiGlowBehavior(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: TournamentTablesSection(
                        driversStandings: controller.currentDrivers.value!,
                        constructorsStandings: controller.currentConstructors.value!,
                        title: context.l10n.homeStandingsTitle,
                        season: controller.currentSeason,
                        round: controller.currentRound,
                        passCurrentRoster: true,
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
