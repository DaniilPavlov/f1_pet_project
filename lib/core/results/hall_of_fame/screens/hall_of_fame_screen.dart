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
import 'package:f1_pet_project/core/results/hall_of_fame/controllers/hall_of_fame_screen_controller/hall_of_fame_screen_controller.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран «Зал славы» с турнирными таблицами за выбранный сезон.
@RoutePage()
class HallOfFameScreen extends ConsumerStatefulWidget {
  const HallOfFameScreen({super.key});

  @override
  ConsumerState<HallOfFameScreen> createState() => _HallOfFameScreenState();
}

class _HallOfFameScreenState extends ConsumerState<HallOfFameScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(analyticsGatewayProvider).log(const HallOfFameOpened());
      return ref.read(hallOfFameScreenControllerProvider.notifier).bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hallOfFameScreenControllerProvider);
    final controller = ref.read(hallOfFameScreenControllerProvider.notifier);
    final isLoading = state.driversStandings.isLoading || state.constructorsStandings.isLoading;

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.hallOfFameTitle, onPop: () => context.router.maybePop()),
      body: SafeArea(
        child: state.screenError != null && !isLoading
            ? ErrorBody(
                onTap: controller.refreshAll,
                title: state.screenError!.title,
                subtitle: state.screenError!.subtitle,
              )
            : RefreshIndicator(
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
                    else if (state.constructorsStandings.value != null && state.driversStandings.value != null)
                      SliverToBoxAdapter(
                        child: TournamentTablesSection(
                          driversStandings: state.driversStandings.value![0].driverStandings!,
                          constructorsStandings: state.constructorsStandings.value![0].constructorStandings!,
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
