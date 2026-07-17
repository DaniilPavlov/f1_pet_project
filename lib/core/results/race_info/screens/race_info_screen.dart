import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/core/results/components/race_info_table.dart';
import 'package:f1_pet_project/core/results/race_info/components/pit_stops_table.dart';
import 'package:f1_pet_project/core/results/race_info/components/pit_stops_table_appbar.dart';
import 'package:f1_pet_project/core/results/race_info/components/qualification_table.dart';
import 'package:f1_pet_project/core/results/race_info/components/qualification_table_appbar.dart';
import 'package:f1_pet_project/core/results/race_info/components/race_info_table_appbar.dart';
import 'package:f1_pet_project/core/results/race_info/controllers/race_info_screen_controller/race_info_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Детальный экран гонки: результаты, спринт, квалификация и пит-стопы.
@RoutePage()
class RaceInfoScreen extends StatelessWidget {
  const RaceInfoScreen({required this.raceModel, super.key});

  final RacesModel raceModel;

  @override
  Widget build(BuildContext context) {
    return Provider<RaceInfoScreenController>(
      create: (_) => RaceInfoScreenController(raceModel: raceModel)..loadAllData(),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Подробная информация', onPop: () => context.router.removeLast()),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<RaceInfoScreenController>();
              if (controller.screenError != null) {
                return ErrorBody(
                  onTap: controller.loadAllData,
                  title: controller.screenError!.title,
                  subtitle: controller.screenError!.subtitle,
                );
              }
              if (!controller.allDataIsLoaded) {
                return const CustomLoadingIndicator();
              }

              final sprintResults = controller.sprintResults.value ?? const [];

              return CustomScrollView(
                scrollBehavior: AntiGlowBehavior(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: StaticData.defaultVerticalPadding,
                        left: StaticData.defaultHorizontalPadding,
                        right: StaticData.defaultHorizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(controller.raceModel.raceName, style: AppStyles.h2),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: StaticData.defaultVerticalPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Сезон: ${controller.raceModel.season}', style: AppStyles.h2),
                                Text('Раунд: ${controller.raceModel.round}', style: AppStyles.h2),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverAppBar(
                    backgroundColor: AppTheme.red,
                    pinned: controller.raceAppBarPinned,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: const RaceInfoTableAppBar(),
                  ),
                  SliverToBoxAdapter(
                    child: VisibilityDetector(
                      key: const Key('race_info_table'),
                      onVisibilityChanged: controller.onRaceTableVisibilityChanged,
                      child: RaceInfoTable(
                        raceModel: controller.raceModel,
                        withPrimaryRow: false,
                      ),
                    ),
                  ),
                  if (sprintResults.isNotEmpty) ...[
                    const SliverToBoxAdapter(child: SizedBox(height: StaticData.defaultVerticalPadding)),
                    SliverAppBar(
                      backgroundColor: AppTheme.red,
                      pinned: controller.sprintAppBarPinned,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0,
                      title: const RaceInfoTableAppBar(title: 'Спринт'),
                    ),
                    SliverToBoxAdapter(
                      child: VisibilityDetector(
                        key: const Key('sprint_info_table'),
                        onVisibilityChanged: controller.onSprintTableVisibilityChanged,
                        child: RaceInfoTable(
                          raceModel: controller.raceModel,
                          results: sprintResults,
                          withPrimaryRow: false,
                        ),
                      ),
                    ),
                  ],
                  const SliverToBoxAdapter(child: SizedBox(height: StaticData.defaultVerticalPadding)),
                  SliverAppBar(
                    backgroundColor: AppTheme.red,
                    pinned: controller.qualificationAppBarPinned,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: const QualificationTableAppBar(),
                  ),
                  SliverToBoxAdapter(
                    child: VisibilityDetector(
                      key: const Key('qualification_info_table'),
                      onVisibilityChanged: controller.onQualificationTableVisibilityChanged,
                      child: QualificationTable(qualifyingResults: controller.qualifyingResults.value!),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: StaticData.defaultVerticalPadding)),
                  SliverAppBar(
                    backgroundColor: AppTheme.red,
                    pinned: controller.pitStopsAppBarPinned,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    title: const PitStopsTableAppBar(),
                  ),
                  SliverToBoxAdapter(
                    child: VisibilityDetector(
                      key: const Key('pit_stops_info_table'),
                      onVisibilityChanged: controller.onPitStopsTableVisibilityChanged,
                      child: PitStopsTable(pitStops: controller.pitStops.value ?? []),
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
