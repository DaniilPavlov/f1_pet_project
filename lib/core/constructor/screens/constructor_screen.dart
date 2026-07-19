import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/career/career_info_row.dart';
import 'package:f1_pet_project/common/widgets/career/career_list_tile.dart';
import 'package:f1_pet_project/common/widgets/career/career_stats_grid.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/core/constructor/controllers/constructor_screen_controller/constructor_screen_controller.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран конструктора: паспортные данные и карьерная статистика.
@RoutePage()
class ConstructorScreen extends StatelessWidget {
  const ConstructorScreen({
    required this.constructor,
    this.currentDrivers = const [],
    super.key,
  });

  final ConstructorModel constructor;
  final List<DriverModel> currentDrivers;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ConstructorScreenController(
        constructor: constructor,
        currentDrivers: currentDrivers,
      )..loadCareerStats(),
      child: Scaffold(
        appBar: CustomAppBar(title: constructor.name, onPop: context.router.removeLast),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<ConstructorScreenController>();
              final error = controller.screenError;
              if (error != null) {
                return ErrorBody(
                  onTap: controller.loadCareerStats,
                  title: error.title,
                  subtitle: error.subtitle,
                );
              }
              if (!controller.isLoaded) {
                return const CustomLoadingIndicator();
              }

              final stats = controller.careerStats.value!;

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
                            value: constructor.nationality.isEmpty
                                ? context.l10n.unknown
                                : constructor.nationality,
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
                          ),
                          const SizedBox(height: 28),
                          Text(context.l10n.constructorDriversTitle, style: AppStyles.h2),
                          const SizedBox(height: 12),
                          ...stats.related.map(
                            (driver) => CareerListTile(
                              title: '${driver.givenName} ${driver.familyName}',
                              subtitle: driver.nationality.isEmpty
                                  ? context.l10n.unknown
                                  : driver.nationality,
                              onTap: () => context.router.push(DriverRoute(driver: driver)),
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
