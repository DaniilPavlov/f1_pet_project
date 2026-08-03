import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/h2h_compare_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/constructor_picker_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/driver_picker_field.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/results/h2h/components/h2h_compare_table.dart';
import 'package:f1_pet_project/core/results/h2h/components/h2h_filters_card.dart';
import 'package:f1_pet_project/core/results/h2h/controllers/h2h_screen_controller/h2h_screen_controller.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/core/results/h2h/repositories/h2h_repository.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран сравнения двух пилотов или конструкторов.
@RoutePage()
class H2hScreen extends StatelessWidget {
  const H2hScreen({this.initialMode = H2hMode.drivers, super.key});

  final H2hMode initialMode;

  @override
  Widget build(BuildContext context) {
    return H2hView(initialMode: initialMode);
  }
}

/// Общий UI H2H (используется и deep-link экраном конструкторов).
class H2hView extends StatelessWidget {
  const H2hView({this.initialMode = H2hMode.drivers, super.key});

  final H2hMode initialMode;

  @override
  Widget build(BuildContext context) {
    return Provider<H2hScreenController>(
      create: (context) => H2hScreenController(
        initialMode: initialMode,
        seasonsRepository: context.read<SeasonsRepository>(),
        h2hRepository: context.read<H2hRepository>(),
        driverCatalogRepository: context.read<DriverCatalogRepository>(),
        constructorCatalogRepository: context.read<ConstructorCatalogRepository>(),
        currentStandingsRepository: context.read<CurrentStandingsRepository>(),
        dataRefresh: context.read<AppDataRefresh>(),
        analytics: context.read<AnalyticsGateway>(),
      )..bootstrap(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.h2hTitle, onPop: () => context.router.maybePop()),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<H2hScreenController>();
              final mode = controller.mode;
              final scopeMode = controller.scopeMode;
              final useCurrentSeason = controller.useCurrentSeason;
              final currentEntitiesOnly = controller.currentEntitiesOnly;
              final isSeasonScope = controller.isSeasonScope;
              final showYearPicker = controller.showYearPicker;
              final latestSeason = controller.latestSeason;
              final canCompare = controller.canCompare;
              final comparison = controller.comparison;
              final isDrivers = controller.isDriversMode;

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
                          SegmentedButton<H2hMode>(
                            showSelectedIcon: false,
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppTheme.red;
                                }
                                return context.colors.white;
                              }),
                              foregroundColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return AppTheme.onChrome;
                                }
                                return context.colors.black;
                              }),
                              side: WidgetStatePropertyAll(
                                BorderSide(color: context.colors.textGray.withValues(alpha: 0.35)),
                              ),
                            ),
                            segments: [
                              ButtonSegment(
                                value: H2hMode.drivers,
                                label: Text(context.l10n.h2hModeDrivers),
                              ),
                              ButtonSegment(
                                value: H2hMode.constructors,
                                label: Text(context.l10n.h2hModeConstructors),
                              ),
                            ],
                            selected: {mode},
                            onSelectionChanged: (value) => controller.setMode(value.first),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isDrivers ? context.l10n.h2hSubtitle : context.l10n.h2hConstructorsSubtitle,
                            style: AppStyles.body,
                          ),
                          const SizedBox(height: 16),
                          H2hFiltersCard(
                            scopeMode: scopeMode,
                            useCurrentSeason: useCurrentSeason,
                            currentEntitiesOnly: currentEntitiesOnly,
                            isSeasonScope: isSeasonScope,
                            showYearPicker: showYearPicker,
                            latestSeason: latestSeason,
                            yearController: controller.yearController,
                            entitiesFilterLabel: isDrivers
                                ? context.l10n.h2hDriversFilter
                                : context.l10n.h2hConstructorsFilter,
                            currentEntitiesTitle: isDrivers
                                ? context.l10n.h2hCurrentDrivers
                                : context.l10n.h2hCurrentConstructors,
                            allEntitiesTitle: isDrivers
                                ? context.l10n.h2hAllDrivers
                                : context.l10n.h2hAllConstructors,
                            onScopeModeChanged: controller.setScopeMode,
                            onUseCurrentSeasonChanged: controller.setUseCurrentSeason,
                            onCurrentEntitiesOnlyChanged: controller.setCurrentEntitiesOnly,
                            onSeasonChanged: controller.onSeasonChanged,
                          ),
                          const SizedBox(height: 20),
                          if (isDrivers) ...[
                            DriverPickerField(
                              label: context.l10n.h2hDriverA,
                              driver: controller.driverA,
                              onChanged: controller.setDriverA,
                              loadDrivers: controller.loadDriversForPicker,
                              enableSearch: !currentEntitiesOnly,
                            ),
                            const SizedBox(height: 12),
                            DriverPickerField(
                              label: context.l10n.h2hDriverB,
                              driver: controller.driverB,
                              onChanged: controller.setDriverB,
                              loadDrivers: controller.loadDriversForPicker,
                              enableSearch: !currentEntitiesOnly,
                            ),
                          ] else ...[
                            ConstructorPickerField(
                              label: context.l10n.h2hConstructorA,
                              constructor: controller.constructorA,
                              onChanged: controller.setConstructorA,
                              loadConstructors: controller.loadConstructorsForPicker,
                              enableSearch: !currentEntitiesOnly,
                            ),
                            const SizedBox(height: 12),
                            ConstructorPickerField(
                              label: context.l10n.h2hConstructorB,
                              constructor: controller.constructorB,
                              onChanged: controller.setConstructorB,
                              loadConstructors: controller.loadConstructorsForPicker,
                              enableSearch: !currentEntitiesOnly,
                            ),
                          ],
                          const SizedBox(height: 20),
                          BlackButton(
                            text: context.l10n.h2hCompare,
                            isDisabled: !canCompare || comparison.isLoading,
                            onTap: controller.compare,
                          ),
                          const SizedBox(height: 24),
                          if (comparison.isLoading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: H2hCompareShimmer(),
                            )
                          else if (comparison.isError)
                            ErrorBody(
                              onTap: controller.refreshComparison,
                              title: controller.screenError!.title,
                              subtitle: controller.screenError!.subtitle,
                            )
                          else if (comparison.value != null)
                            H2hCompareTable(
                              nameA: comparison.value!.nameA,
                              nameB: comparison.value!.nameB,
                              statsA: comparison.value!.statsA,
                              statsB: comparison.value!.statsB,
                              timeline: comparison.value!.timeline,
                              season: comparison.value!.season,
                              constructorIdA: comparison.value!.constructorIdA,
                              constructorIdB: comparison.value!.constructorIdB,
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
