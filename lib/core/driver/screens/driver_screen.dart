import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/core/driver/controllers/driver_screen_controller/driver_screen_controller.dart';
import 'package:f1_pet_project/core/driver/models/driver_career_stats.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Экран пилота: паспортные данные и карьерная статистика.
@RoutePage()
class DriverScreen extends StatelessWidget {
  const DriverScreen({required this.driver, super.key});

  final DriverModel driver;

  @override
  Widget build(BuildContext context) {
    final fullName = '${driver.givenName} ${driver.familyName}';

    return Provider(
      create: (_) => DriverScreenController(driver: driver)..loadCareerStats(),
      child: Scaffold(
        appBar: CustomAppBar(title: fullName, onPop: context.router.removeLast),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<DriverScreenController>();
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
                          Text(fullName, style: AppStyles.h1),
                          const SizedBox(height: 16),
                          _InfoRow(label: context.l10n.driverCode, value: _displayOrDash(driver.code)),
                          _InfoRow(label: context.l10n.driverNumber, value: _displayOrDash(driver.permanentNumber)),
                          _InfoRow(label: context.l10n.nationality, value: driver.nationality),
                          _InfoRow(
                            label: context.l10n.dateOfBirth,
                            value: _formatBirthDate(context, driver.dateOfBirth),
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
                          Text(context.l10n.driverCareerTitle, style: AppStyles.h2),
                          const SizedBox(height: 16),
                          _StatsGrid(stats: stats),
                          const SizedBox(height: 28),
                          Text(context.l10n.driverTeamsTitle, style: AppStyles.h2),
                          const SizedBox(height: 12),
                          ...stats.constructors.map(_ConstructorTile.new),
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

  static String _displayOrDash(String? value) {
    if (value == null || value.isEmpty || value == 'none') {
      return '—';
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppStyles.body.copyWith(color: AppTheme.textGray))),
          Expanded(child: Text(value, style: AppStyles.body, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.stats});

  final DriverCareerStats stats;

  @override
  Widget build(BuildContext context) {
    final items = [
      (context.l10n.driverStatRaces, stats.races),
      (context.l10n.wins, stats.wins),
      (context.l10n.driverStatPodiums, stats.podiums),
      (context.l10n.driverStatPoles, stats.poles),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.85,
      children: [
        for (final (label, value) in items)
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.red),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$value', style: AppStyles.h2),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.body.copyWith(color: AppTheme.textGray),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ConstructorTile extends StatelessWidget {
  const _ConstructorTile(this.constructor);

  final ConstructorModel constructor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(constructor.name, style: AppStyles.body)),
          Text(constructor.nationality, style: AppStyles.body.copyWith(color: AppTheme.textGray)),
        ],
      ),
    );
  }
}
