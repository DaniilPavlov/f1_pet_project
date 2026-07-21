import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/helpers/share_helper.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/career/career_info_row.dart';
import 'package:f1_pet_project/common/widgets/career/career_list_tile.dart';
import 'package:f1_pet_project/common/widgets/career/career_race_results_sheet.dart';
import 'package:f1_pet_project/common/widgets/career/career_stats_grid.dart';
import 'package:f1_pet_project/common/widgets/career/espn_driver_news_section.dart';
import 'package:f1_pet_project/common/widgets/country_flag.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/career_screen_shimmer.dart';
import 'package:f1_pet_project/core/constructor/controllers/constructor_screen_controller/constructor_screen_controller.dart';
import 'package:f1_pet_project/core/espn/repositories/espn_media_repository.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран конструктора: информация о конструкторе и карьерная статистика.
@RoutePage()
class ConstructorScreen extends StatelessWidget {
  const ConstructorScreen({required this.constructor, this.currentDrivers = const [], super.key});

  final ConstructorModel constructor;
  final List<DriverModel> currentDrivers;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ConstructorScreenController(
        constructor: constructor,
        currentDrivers: currentDrivers,
        espnMediaRepository: context.read<EspnMediaRepository>(),
      )..loadAll(),
      child: Observer(
        builder: (context) {
          final controller = context.read<ConstructorScreenController>();
          final stats = controller.careerStats.value;

          return Scaffold(
            appBar: CustomAppBar(
              title: constructor.name,
              onPop: context.router.removeLast,
              onShare: stats == null
                  ? null
                  : () => ShareHelper.shareCareerCard(
                      context: context,
                      l10n: context.l10n,
                      title: constructor.name,
                      stats: stats,
                    ),
            ),
            body: SafeArea(
              child: Builder(
                builder: (context) {
                  final error = controller.screenError;
                  if (error != null) {
                    return ErrorBody(onTap: controller.loadAll, title: error.title, subtitle: error.subtitle);
                  }
                  if (!controller.isLoaded || stats == null) {
                    return const CareerScreenShimmer(showPhoto: false);
                  }

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
                              Text(constructor.name, style: AppStyles.h1),
                              const SizedBox(height: 16),
                              CareerInfoRow(
                                label: context.l10n.nationality,
                                valueWidget: CountryFlag(
                                  countryOrNationality: constructor.nationality,
                                  fontSize: 28,
                                  fallbackStyle: AppStyles.body,
                                ),
                              ),
                              if (stats.current.isNotEmpty)
                                CareerInfoRow(
                                  label: context.l10n.currentDrivers,
                                  value: stats.current
                                      .map((d) => '${d.givenName} ${d.familyName}'.trim())
                                      .where((name) => name.isNotEmpty)
                                      .join(', '),
                                ),
                              if (constructor.url.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () => Utils.openUrl(rawUrl: constructor.url, externalApplication: true),
                                  child: Text(
                                    context.l10n.openInWikipedia,
                                    style: AppStyles.body.copyWith(decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 28),
                              Text(context.l10n.careerTitle, style: AppStyles.h2),
                              const SizedBox(height: 16),
                              CareerStatsGrid(
                                races: stats.races,
                                wins: stats.wins,
                                podiums: stats.podiums,
                                poles: stats.poles,
                                onWinsTap: () => showCareerRaceResultsSheet(
                                  context: context,
                                  title: context.l10n.wins,
                                  races: stats.winRaces,
                                  showPosition: false,
                                ),
                                onPodiumsTap: () => showCareerRaceResultsSheet(
                                  context: context,
                                  title: context.l10n.careerStatPodiums,
                                  races: stats.podiumRaces,
                                  showPosition: true,
                                ),
                                onPolesTap: () => showCareerRaceResultsSheet(
                                  context: context,
                                  title: context.l10n.careerStatPoles,
                                  races: stats.poleRaces,
                                  showPosition: false,
                                ),
                              ),
                              const SizedBox(height: 28),
                              Text(context.l10n.constructorDriversTitle, style: AppStyles.h2),
                              const SizedBox(height: 12),
                              ...stats.related.map(
                                (driver) => CareerListTile(
                                  title: '${driver.givenName} ${driver.familyName}',
                                  trailing: CountryFlag(countryOrNationality: driver.nationality),
                                  onTap: () => context.router.push(DriverRoute(driver: driver)),
                                ),
                              ),
                              EspnDriverNewsSection(news: controller.news),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
