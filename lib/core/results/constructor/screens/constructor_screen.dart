import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/constructor_colors.dart';
import 'package:f1_pet_project/common/utils/helpers/share_helper.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
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
import 'package:f1_pet_project/core/results/constructor/controllers/constructor_screen_controller/constructor_screen_controller.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/deeplinks/f1pet_deep_links.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран конструктора: информация о конструкторе и карьерная статистика.
@RoutePage()
class ConstructorScreen extends ConsumerStatefulWidget {
  const ConstructorScreen({required this.constructor, this.currentDrivers = const [], super.key});

  final ConstructorModel constructor;
  final List<DriverModel> currentDrivers;

  @override
  ConsumerState<ConstructorScreen> createState() => _ConstructorScreenState();
}

class _ConstructorScreenState extends ConsumerState<ConstructorScreen> {
  late final ConstructorScreenArgs _args;

  @override
  void initState() {
    super.initState();
    _args = ConstructorScreenArgs(
      constructor: widget.constructor,
      currentDrivers: widget.currentDrivers,
    );
    Future.microtask(() {
      ref.read(analyticsGatewayProvider).log(
            ConstructorOpened(
              constructorId: widget.constructor.constructorId,
              constructorName: widget.constructor.name,
            ),
          );
      return ref.read(constructorScreenControllerProvider(_args).notifier).loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final constructor = widget.constructor;
    final state = ref.watch(constructorScreenControllerProvider(_args));
    final controller = ref.read(constructorScreenControllerProvider(_args).notifier);
    final stats = state.careerStats.value;

    return Scaffold(
      appBar: CustomAppBar(
        title: constructor.name,
        showPreferences: false,
        onPop: () => context.router.maybePop(),
        onShare: stats == null
            ? null
            : () => ShareHelper.shareCareerCard(
                context: context,
                l10n: context.l10n,
                title: constructor.name,
                stats: stats,
                deepLink: F1PetDeepLinks.constructor(constructor.constructorId),
              ),
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            final error = state.screenError;
            if (error != null) {
              return ErrorBody(onTap: controller.refreshAll, title: error.title, subtitle: error.subtitle);
            }
            if (!state.isLoaded || stats == null) {
              return const CareerScreenShimmer(showPhoto: false);
            }

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
                          Text(constructor.name, style: AppStyles.h1),
                          const SizedBox(height: 8),
                          Container(
                            width: 48,
                            height: 3,
                            decoration: BoxDecoration(
                              color: ConstructorColors.forConstructorId(constructor.constructorId),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
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
                          EspnDriverNewsSection(news: state.news),
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
    );
  }
}
