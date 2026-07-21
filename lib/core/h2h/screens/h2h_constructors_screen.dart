import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/constructor_picker_field.dart';
import 'package:f1_pet_project/core/h2h/components/h2h_compare_table.dart';
import 'package:f1_pet_project/core/h2h/components/h2h_filters_card.dart';
import 'package:f1_pet_project/core/h2h/controllers/h2h_constructors_screen_controller/h2h_constructors_screen_controller.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран сравнения двух конструкторов с блоком фильтров.
@RoutePage()
class H2hConstructorsScreen extends StatelessWidget {
  const H2hConstructorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<H2hConstructorsScreenController>(
      create: (_) => H2hConstructorsScreenController(
        seasonsRepository: context.read<SeasonsRepository>(),
      )..bootstrap(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.h2hConstructorsTitle, onPop: context.router.removeLast),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              // Читаем здесь — иначе CustomScrollView откладывает build и MobX не подписывается.
              final controller = context.read<H2hConstructorsScreenController>();
              final scopeMode = controller.scopeMode;
              final useCurrentSeason = controller.useCurrentSeason;
              final currentConstructorsOnly = controller.currentConstructorsOnly;
              final isSeasonScope = controller.isSeasonScope;
              final showYearPicker = controller.showYearPicker;
              final latestSeason = controller.latestSeason;
              final canCompare = controller.canCompare;
              final comparison = controller.comparison;
              final constructorA = controller.constructorA;
              final constructorB = controller.constructorB;

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
                          Text(context.l10n.h2hConstructorsSubtitle, style: AppStyles.body),
                          const SizedBox(height: 16),
                          H2hFiltersCard(
                            scopeMode: scopeMode,
                            useCurrentSeason: useCurrentSeason,
                            currentEntitiesOnly: currentConstructorsOnly,
                            isSeasonScope: isSeasonScope,
                            showYearPicker: showYearPicker,
                            latestSeason: latestSeason,
                            yearController: controller.yearController,
                            entitiesFilterLabel: context.l10n.h2hConstructorsFilter,
                            currentEntitiesTitle: context.l10n.h2hCurrentConstructors,
                            allEntitiesTitle: context.l10n.h2hAllConstructors,
                            onScopeModeChanged: controller.setScopeMode,
                            onUseCurrentSeasonChanged: controller.setUseCurrentSeason,
                            onCurrentEntitiesOnlyChanged: controller.setCurrentConstructorsOnly,
                            onSeasonChanged: controller.onSeasonChanged,
                          ),
                          const SizedBox(height: 20),
                          ConstructorPickerField(
                            label: context.l10n.h2hConstructorA,
                            constructor: constructorA,
                            onChanged: controller.setConstructorA,
                            loadConstructors: controller.loadConstructorsForPicker,
                            enableSearch: !currentConstructorsOnly,
                          ),
                          const SizedBox(height: 12),
                          ConstructorPickerField(
                            label: context.l10n.h2hConstructorB,
                            constructor: constructorB,
                            onChanged: controller.setConstructorB,
                            loadConstructors: controller.loadConstructorsForPicker,
                            enableSearch: !currentConstructorsOnly,
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
                              onTap: controller.compare,
                              title: controller.screenError!.title,
                              subtitle: controller.screenError!.subtitle,
                            )
                          else if (comparison.value != null)
                            H2hCompareTable(
                              nameA: comparison.value!.constructorA.name,
                              nameB: comparison.value!.constructorB.name,
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
