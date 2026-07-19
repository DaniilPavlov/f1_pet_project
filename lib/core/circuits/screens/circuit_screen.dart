import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/career/career_list_tile.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/core/circuits/controllers/circuit_screen_controller/circuit_screen_controller.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран трассы: информация о трассе и история побед.
@RoutePage()
class CircuitScreen extends StatelessWidget {
  const CircuitScreen({required this.circuitModel, super.key});

  final CircuitModel circuitModel;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CircuitScreenController(circuit: circuitModel)..loadWinners(),
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.circuitInfoTitle, onPop: context.router.removeLast),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<CircuitScreenController>();
              final error = controller.screenError;
              if (error != null) {
                return ErrorBody(onTap: controller.loadWinners, title: error.title, subtitle: error.subtitle);
              }
              if (!controller.isLoaded) {
                return const CustomLoadingIndicator();
              }

              final wins = controller.winners.value!;

              return CustomScrollView(
                scrollBehavior: AntiGlowBehavior(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StaticData.defaultHorizontalPadding,
                        vertical: StaticData.defaultVerticalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(circuitModel.circuitName, style: AppStyles.h1),
                          const SizedBox(height: 16),
                          if (circuitModel.url.isNotEmpty)
                            GestureDetector(
                              onTap: () => Utils.openUrl(rawUrl: circuitModel.url, externalApplication: true),
                              child: Text(
                                context.l10n.readOnWikipedia,
                                style: AppStyles.body.copyWith(decoration: TextDecoration.underline),
                              ),
                            ),
                          const SizedBox(height: 16),
                          Text(context.l10n.countryLabel(circuitModel.location.country), style: AppStyles.h3),
                          const SizedBox(height: 10),
                          Text(context.l10n.cityLabel(circuitModel.location.locality), style: AppStyles.h3),
                          const SizedBox(height: 28),
                          Text(context.l10n.circuitWinnersTitle, style: AppStyles.h2),
                          const SizedBox(height: 12),
                          if (wins.isEmpty)
                            Text(context.l10n.circuitWinnersEmpty, style: AppStyles.body)
                          else
                            ...wins.map(
                              (win) => CareerListTile(
                                title: '${win.season} · ${win.raceName}',
                                subtitle: '${win.driverFullName} · ${win.constructor.name}',
                                onTap: () => context.router.push(DriverRoute(driver: win.driver)),
                              ),
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
