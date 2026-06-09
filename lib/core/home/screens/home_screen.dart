import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/core/home/components/home_tournament_tables_section.dart';
import 'package:f1_pet_project/core/home/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<HomeScreenController>(
      create: (_) => HomeScreenController()..loadAllData(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<HomeScreenController>();
              if (controller.currentDrivers.isLoading || controller.currentConstructors.isLoading) {
                return const CustomLoadingIndicator();
              }
              if (controller.screenError != null) {
                return ErrorBody(
                  onTap: controller.loadAllData,
                  title: controller.screenError!.title,
                  subtitle: controller.screenError!.subtitle,
                );
              }

              return CustomScrollView(
                scrollBehavior: AntiGlowBehavior(),
                slivers: [
                  SliverToBoxAdapter(
                    child: HomeTournamentTablesSection(
                      driversStandings: controller.currentDrivers.value!,
                      constructorsStandings: controller.currentConstructors.value!,
                      season: controller.currentSeason,
                      round: controller.currentRound,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
