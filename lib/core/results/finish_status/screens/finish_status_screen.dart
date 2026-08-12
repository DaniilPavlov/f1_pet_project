import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_field.dart';
import 'package:f1_pet_project/core/results/finish_status/components/finish_status_share_list.dart';
import 'package:f1_pet_project/core/results/finish_status/controllers/finish_status_screen_controller/finish_status_screen_controller.dart';
import 'package:f1_pet_project/core/results/finish_status/repositories/finish_status_repository.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Статусы финиша сезона (Finished / Retired / DSQ / +N laps и т.д.).
@RoutePage()
class FinishStatusScreen extends StatelessWidget {
  const FinishStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<FinishStatusScreenController>(
      create: (context) => FinishStatusScreenController(
        seasonsRepository: context.read<SeasonsRepository>(),
        finishStatusRepository: context.read<FinishStatusRepository>(),
        dataRefresh: context.read<AppDataRefresh>(),
      )..bootstrap(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.finishStatusTitle, onPop: () => context.router.maybePop()),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<FinishStatusScreenController>();

              return RefreshIndicator(
                color: AppTheme.red,
                onRefresh: controller.refreshAll,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                            Text(context.l10n.finishStatusSubtitle, style: AppStyles.body),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              child: SeasonPickerField(
                                controller: controller.yearController,
                                onChanged: controller.loadAllData,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (controller.statuses.isLoading)
                              const ListRowsShimmer(
                                rowCount: 8,
                                padding: EdgeInsets.zero,
                                rowHeight: 20,
                                rowRadius: 4,
                                rowGap: 20,
                              )
                            else if (controller.statuses.isError)
                              ErrorBody(
                                onTap: controller.refreshAll,
                                title: controller.screenError!.title,
                                subtitle: controller.screenError!.subtitle,
                              )
                            else
                              FinishStatusShareList(items: controller.statuses.value ?? const []),
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
