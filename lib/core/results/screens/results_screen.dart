import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/core/results/components/last_race_table_section.dart';
import 'package:f1_pet_project/core/results/controllers/results_screen_controller/results_screen_controller.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<ResultsScreenController>(
      create: (_) => ResultsScreenController()..loadAllData(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<ResultsScreenController>();
              if (controller.lastRace.isLoading) {
                return const CustomLoadingIndicator();
              }
              if (controller.lastRace.isError || controller.screenError != null) {
                return ErrorBody(
                  onTap: controller.loadAllData,
                  title: controller.screenError?.title ?? controller.lastRace.error!.errorMessage,
                  subtitle: controller.screenError?.subtitle,
                );
              }

              return CustomScrollView(
                scrollBehavior: AntiGlowBehavior(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: StaticData.defaultVerticalPadding),
                      child: LastRaceTableSection(lastRace: controller.lastRace.value!),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StaticData.defaultHorizontalPadding,
                        vertical: StaticData.defaultVerticalPadding,
                      ),
                      child: RedBorderContainer(
                        title: 'Выбрать конкретную гонку',
                        onTap: () async => context.router.navigate(const RaceSearchRoute()),
                      ),
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
