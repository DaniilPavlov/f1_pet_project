import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/driver_picker_field.dart';
import 'package:f1_pet_project/core/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/h2h/components/h2h_compare_table.dart';
import 'package:f1_pet_project/core/h2h/components/h2h_filters_card.dart';
import 'package:f1_pet_project/core/h2h/controllers/h2h_screen_controller/h2h_screen_controller.dart';
import 'package:f1_pet_project/core/h2h/repositories/h2h_repository.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран сравнения двух пилотов с единым блоком фильтров.
@RoutePage()
class H2hScreen extends StatelessWidget {
  const H2hScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<H2hScreenController>(
      create: (context) => H2hScreenController(
        seasonsRepository: context.read<SeasonsRepository>(),
        h2hRepository: context.read<H2hRepository>(),
        driverCatalogRepository: context.read<DriverCatalogRepository>(),
        dataRefresh: context.read<AppDataRefresh>(),
      )..bootstrap(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.h2hTitle, onPop: context.router.removeLast),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<H2hScreenController>();
              // Читаем здесь — иначе CustomScrollView откладывает build и MobX не подписывается.
              final scopeMode = controller.scopeMode;
              final useCurrentSeason = controller.useCurrentSeason;
              final currentDriversOnly = controller.currentDriversOnly;
              final isSeasonScope = controller.isSeasonScope;
              final showYearPicker = controller.showYearPicker;
              final latestSeason = controller.latestSeason;
              final canCompare = controller.canCompare;
              final comparison = controller.comparison;
              final driverA = controller.driverA;
              final driverB = controller.driverB;

              return CustomScrollView(
                scrollBehavior: AntiGlowBehavior(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        StaticData.defaultHorizontalPadding,
                        StaticData.defaultVerticalPadding,
                        StaticData.defaultHorizontalPadding,
                        StaticData.defaultVerticalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.h2hSubtitle, style: AppStyles.body),
                          const SizedBox(height: 16),
                          H2hFiltersCard(
                            scopeMode: scopeMode,
                            useCurrentSeason: useCurrentSeason,
                            currentEntitiesOnly: currentDriversOnly,
                            isSeasonScope: isSeasonScope,
                            showYearPicker: showYearPicker,
                            latestSeason: latestSeason,
                            yearController: controller.yearController,
                            entitiesFilterLabel: context.l10n.h2hDriversFilter,
                            currentEntitiesTitle: context.l10n.h2hCurrentDrivers,
                            allEntitiesTitle: context.l10n.h2hAllDrivers,
                            onScopeModeChanged: controller.setScopeMode,
                            onUseCurrentSeasonChanged: controller.setUseCurrentSeason,
                            onCurrentEntitiesOnlyChanged: controller.setCurrentDriversOnly,
                            onSeasonChanged: controller.onSeasonChanged,
                          ),
                          const SizedBox(height: 20),
                          DriverPickerField(
                            label: context.l10n.h2hDriverA,
                            driver: driverA,
                            onChanged: controller.setDriverA,
                            loadDrivers: controller.loadDriversForPicker,
                            enableSearch: !currentDriversOnly,
                          ),
                          const SizedBox(height: 12),
                          DriverPickerField(
                            label: context.l10n.h2hDriverB,
                            driver: driverB,
                            onChanged: controller.setDriverB,
                            loadDrivers: controller.loadDriversForPicker,
                            enableSearch: !currentDriversOnly,
                          ),
                          const SizedBox(height: 20),
                          BlackButton(
                            text: context.l10n.h2hCompare,
                            isDisabled: !canCompare || comparison.isLoading,
                            onTap: controller.compare,
                          ),
                          const SizedBox(height: 24),
                          if (comparison.isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: ListRowsShimmer(rowCount: 4, padding: EdgeInsets.zero),
                            )
                          else if (comparison.isError)
                            ErrorBody(
                              onTap: controller.refreshComparison,
                              title: controller.screenError!.title,
                              subtitle: controller.screenError!.subtitle,
                            )
                          else if (comparison.value != null)
                            H2hCompareTable(
                              nameA:
                                  '${comparison.value!.driverA.givenName} ${comparison.value!.driverA.familyName}'
                                      .trim(),
                              nameB:
                                  '${comparison.value!.driverB.givenName} ${comparison.value!.driverB.familyName}'
                                      .trim(),
                              statsA: comparison.value!.statsA,
                              statsB: comparison.value!.statsB,
                              season: comparison.value!.season,
                            ),
                        ],
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
