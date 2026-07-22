import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/circuits/circuit_layout_assets.dart';
import 'package:f1_pet_project/common/circuits/circuit_stats_repository.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/career/career_list_tile.dart';
import 'package:f1_pet_project/common/widgets/career/network_hero_photo.dart';
import 'package:f1_pet_project/common/widgets/circuits/circuit_layout_image.dart';
import 'package:f1_pet_project/common/widgets/circuits/circuit_stats_grid.dart';
import 'package:f1_pet_project/common/widgets/country_flag.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/career_screen_shimmer.dart';
import 'package:f1_pet_project/common/wikipedia/repositories/wikipedia_page_image_repository.dart';
import 'package:f1_pet_project/core/circuits/controllers/circuit_screen_controller/circuit_screen_controller.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран трассы: схема, stats, информация и история побед.
@RoutePage()
class CircuitScreen extends StatelessWidget {
  const CircuitScreen({required this.circuitModel, super.key});

  final CircuitModel circuitModel;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CircuitScreenController(
        circuit: circuitModel,
        statsRepository: context.read<CircuitStatsRepository>(),
        circuitsRepository: context.read<CircuitsRepository>(),
        wikipediaRepository: context.read<WikipediaPageImageRepository>(),
        dataRefresh: context.read<AppDataRefresh>(),
      )..loadAll(),
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.circuitInfoTitle, onPop: context.router.removeLast),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<CircuitScreenController>();
              final error = controller.screenError;
              if (error != null) {
                return ErrorBody(onTap: controller.refreshAll, title: error.title, subtitle: error.subtitle);
              }
              if (!controller.isLoaded) {
                return const CareerScreenShimmer();
              }

              final wins = controller.winners.value!;
              final hasLayout = CircuitLayoutAssets.hasLayout(circuitModel.circuitId);
              final stats = controller.circuitStats;

              return RefreshIndicator(
                color: AppTheme.red,
                onRefresh: controller.refreshAll,
                child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                          if (hasLayout)
                            CircuitLayoutImage(circuitId: circuitModel.circuitId, height: 220)
                          else
                            NetworkHeroPhoto(
                              photoUrl: controller.circuitPhotoUrl,
                              isLoading: controller.isPhotoLoading,
                              placeholderIcon: Icons.map_outlined,
                              fit: BoxFit.contain,
                            ),
                          const SizedBox(height: 16),
                          Text(circuitModel.circuitName, style: AppStyles.h1),
                          if (stats != null) ...[
                            const SizedBox(height: 16),
                            CircuitStatsGrid(stats: stats),
                          ],
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
                          Row(
                            children: [
                              Text('${context.l10n.country}: ', style: AppStyles.h3),
                              CountryFlag(
                                countryOrNationality: circuitModel.location.country,
                                fontSize: 28,
                                fallbackStyle: AppStyles.h3,
                              ),
                            ],
                          ),
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
              ),
              );
            },
          ),
        ),
      ),
    );
  }
}
