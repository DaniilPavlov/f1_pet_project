import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
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
import 'package:f1_pet_project/core/results/h2h/components/h2h_compare_table.dart';
import 'package:f1_pet_project/core/results/h2h/components/h2h_filters_card.dart';
import 'package:f1_pet_project/core/results/h2h/controllers/h2h_screen_controller/h2h_screen_controller.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
class H2hView extends ConsumerStatefulWidget {
  const H2hView({this.initialMode = H2hMode.drivers, super.key});

  final H2hMode initialMode;

  @override
  ConsumerState<H2hView> createState() => _H2hViewState();
}

class _H2hViewState extends ConsumerState<H2hView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(h2hScreenControllerProvider(widget.initialMode).notifier).bootstrap());
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.initialMode;
    final state = ref.watch(h2hScreenControllerProvider(mode));
    final controller = ref.read(h2hScreenControllerProvider(mode).notifier);
    final isDrivers = state.isDriversMode;
    final comparison = state.comparison;

    return Scaffold(
      appBar: CustomAppBar(title: context.l10n.h2hTitle, onPop: () => context.router.maybePop()),
      body: SafeArea(
        child: CustomScrollView(
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
                      selected: {state.mode},
                      onSelectionChanged: (value) => controller.setMode(value.first),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isDrivers ? context.l10n.h2hSubtitle : context.l10n.h2hConstructorsSubtitle,
                      style: AppStyles.body,
                    ),
                    const SizedBox(height: 16),
                    H2hFiltersCard(
                      scopeMode: state.scopeMode,
                      useCurrentSeason: state.useCurrentSeason,
                      currentEntitiesOnly: state.currentEntitiesOnly,
                      isSeasonScope: state.isSeasonScope,
                      showYearPicker: state.showYearPicker,
                      latestSeason: state.latestSeason,
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
                        driver: state.driverA,
                        onChanged: controller.setDriverA,
                        loadDrivers: controller.loadDriversForPicker,
                        enableSearch: !state.currentEntitiesOnly,
                      ),
                      const SizedBox(height: 12),
                      DriverPickerField(
                        label: context.l10n.h2hDriverB,
                        driver: state.driverB,
                        onChanged: controller.setDriverB,
                        loadDrivers: controller.loadDriversForPicker,
                        enableSearch: !state.currentEntitiesOnly,
                      ),
                    ] else ...[
                      ConstructorPickerField(
                        label: context.l10n.h2hConstructorA,
                        constructor: state.constructorA,
                        onChanged: controller.setConstructorA,
                        loadConstructors: controller.loadConstructorsForPicker,
                        enableSearch: !state.currentEntitiesOnly,
                      ),
                      const SizedBox(height: 12),
                      ConstructorPickerField(
                        label: context.l10n.h2hConstructorB,
                        constructor: state.constructorB,
                        onChanged: controller.setConstructorB,
                        loadConstructors: controller.loadConstructorsForPicker,
                        enableSearch: !state.currentEntitiesOnly,
                      ),
                    ],
                    const SizedBox(height: 20),
                    BlackButton(
                      text: context.l10n.h2hCompare,
                      isDisabled: !controller.canCompare || comparison.isLoading,
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
                        title: state.screenError!.title,
                        subtitle: state.screenError!.subtitle,
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
        ),
      ),
    );
  }
}
