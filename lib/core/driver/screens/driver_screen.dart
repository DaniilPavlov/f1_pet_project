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
import 'package:f1_pet_project/core/driver/controllers/driver_screen_controller/driver_screen_controller.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Экран пилота: информация о пилоте и карьерная статистика.
@RoutePage()
class DriverScreen extends StatelessWidget {
  const DriverScreen({required this.driver, this.currentConstructors = const [], super.key});

  final DriverModel driver;
  final List<ConstructorModel> currentConstructors;

  @override
  Widget build(BuildContext context) {
    final fullName = '${driver.givenName} ${driver.familyName}';

    return Provider(
      create: (_) =>
          DriverScreenController(driver: driver, currentConstructors: currentConstructors)..loadCareerStats(),
      child: Scaffold(
        appBar: CustomAppBar(title: fullName, onPop: context.router.removeLast),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<DriverScreenController>();
              final error = controller.screenError;
              if (error != null) {
                return ErrorBody(onTap: controller.loadCareerStats, title: error.title, subtitle: error.subtitle);
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
                          Text(fullName, style: AppStyles.h1),
                          const SizedBox(height: 16),
                          CareerInfoRow(label: context.l10n.driverCode, value: _displayValue(context, driver.code)),
                          CareerInfoRow(
                            label: context.l10n.driverNumber,
                            value: _displayValue(context, driver.permanentNumber),
                          ),
                          CareerInfoRow(
                            label: context.l10n.nationality,
                            value: _displayValue(context, driver.nationality),
                          ),
                          CareerInfoRow(
                            label: context.l10n.dateOfBirth,
                            value: driver.dateOfBirth.isEmpty
                                ? context.l10n.unknown
                                : _formatBirthDate(context, driver.dateOfBirth),
                          ),
                          if (stats.current.isNotEmpty)
                            CareerInfoRow(
                              label: context.l10n.currentTeam,
                              value: stats.current.map((c) => c.name).join(', '),
                            ),
                          if (driver.url.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () => Utils.openUrl(rawUrl: driver.url, externalApplication: true),
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
                          Text(context.l10n.driverTeamsTitle, style: AppStyles.h2),
                          const SizedBox(height: 12),
                          ...stats.related.map(
                            (constructor) => CareerListTile(
                              title: constructor.name,
                              subtitle: _displayValue(context, constructor.nationality),
                              onTap: () => context.router.push(ConstructorRoute(constructor: constructor)),
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

  static String _displayValue(BuildContext context, String? value) {
    if (value == null || value.isEmpty || value == 'none') {
      return context.l10n.unknown;
    }
    return value;
  }

  static String _formatBirthDate(BuildContext context, String raw) {
    final parts = raw.split('-');
    if (parts.length != 3) {
      return raw;
    }
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) {
      return raw;
    }
    return DateFormat.yMMMMd(Localizations.localeOf(context).toLanguageTag()).format(DateTime(year, month, day));
  }
}
