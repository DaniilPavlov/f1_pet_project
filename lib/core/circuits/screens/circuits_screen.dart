import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/custom_switcher.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/core/circuits/components/circuits_list.dart';
import 'package:f1_pet_project/core/circuits/components/circuits_map.dart';
import 'package:f1_pet_project/core/circuits/controllers/circuits_screen_controller/circuits_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран списка трасс с переключением между картой и списком.
@RoutePage()
class CircuitsScreen extends StatelessWidget {
  const CircuitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<CircuitsScreenController>(
      create: (_) => CircuitsScreenController()..loadCircuits(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<CircuitsScreenController>();
              if (controller.circuits.isLoading) {
                return const CustomLoadingIndicator();
              }
              if (controller.circuits.isError) {
                return ErrorBody(
                  onTap: controller.loadCircuits,
                  title: controller.screenError!.title,
                  subtitle: controller.screenError!.subtitle,
                );
              }

              final circuits = controller.circuits.value ?? [];
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
                        CircuitsList(circuits: circuits),
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
