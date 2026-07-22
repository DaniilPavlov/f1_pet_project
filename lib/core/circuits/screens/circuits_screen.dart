import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/custom_switcher.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/core/circuits/components/circuits_list.dart';
import 'package:f1_pet_project/core/circuits/components/circuits_map_stub.dart'
    if (dart.library.io) 'package:f1_pet_project/core/circuits/components/circuits_map.dart';
import 'package:f1_pet_project/core/circuits/controllers/circuits_screen_controller/circuits_screen_controller.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран списка трасс с переключением между картой и списком (на web — только список).
///
/// GoF Structural Bridge — абстракция `CircuitsMap` отделена от платформы:
/// stub на web и MapKit на IO через conditional import.
@RoutePage()
class CircuitsScreen extends StatelessWidget {
  const CircuitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<CircuitsScreenController>(
      create: (context) => CircuitsScreenController(
        circuitsRepository: context.read<CircuitsRepository>(),
        dataRefresh: context.read<AppDataRefresh>(),
      )..loadCircuits(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<CircuitsScreenController>();
              if (controller.circuits.isLoading) {
                return const CircuitsShimmer();
              }
              if (controller.circuits.isError) {
                return ErrorBody(
                  onTap: controller.refreshAll,
                  title: controller.screenError!.title,
                  subtitle: controller.screenError!.subtitle,
                );
              }

              final circuits = controller.circuits.value ?? [];
              if (!PlatformCapabilities.hasYandexMap) {
                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(context.l10n.circuitsMapWebUnavailable, textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: RefreshIndicator(
                        color: AppTheme.red,
                        onRefresh: controller.refreshAll,
                        child: CircuitsList(circuits: circuits),
                      ),
                    ),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 12),
                  CustomSwitcher(
                    firstTitle: context.l10n.onMap,
                    secondTitle: context.l10n.asList,
                    onChanged: controller.changeActivePage,
                    activeValue: controller.activePage,
                  ),
                  Expanded(
                    child: PageView(
                      onPageChanged: controller.changeActivePage,
                      controller: controller.pageController,
                      children: [
                        CircuitsMap(circuits: circuits),
                        RefreshIndicator(
                          color: AppTheme.red,
                          onRefresh: controller.refreshAll,
                          child: CircuitsList(circuits: circuits),
                        ),
                      ],
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
