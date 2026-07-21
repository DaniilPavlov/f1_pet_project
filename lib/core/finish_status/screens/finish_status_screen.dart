import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_field.dart';
import 'package:f1_pet_project/core/finish_status/controllers/finish_status_screen_controller/finish_status_screen_controller.dart';
import 'package:f1_pet_project/core/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
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
      create: (_) => FinishStatusScreenController(
        seasonsRepository: context.read<SeasonsRepository>(),
      )..bootstrap(),
      dispose: (_, controller) => controller.dispose(),
      child: Scaffold(
        appBar: CustomAppBar(title: context.l10n.finishStatusTitle, onPop: context.router.removeLast),
        body: SafeArea(
          child: Observer(
            builder: (context) {
              final controller = context.read<FinishStatusScreenController>();

              return CustomScrollView(
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
                            const ListRowsShimmer(rowCount: 8, padding: EdgeInsets.zero)
                          else if (controller.statuses.isError)
                            ErrorBody(
                              onTap: controller.loadAllData,
                              title: controller.screenError!.title,
                              subtitle: controller.screenError!.subtitle,
                            )
                          else
                            _StatusList(items: controller.statuses.value ?? const []),
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

class _StatusList extends StatelessWidget {
  const _StatusList({required this.items});

  final List<FinishStatusItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(context.l10n.finishStatusEmpty, style: AppStyles.body),
      );
    }

    final total = items.fold<int>(0, (sum, item) => sum + item.count);

    return Column(
      children: [
        for (final item in items) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.status,
                    style: AppStyles.body.copyWith(
                      fontWeight: item.isHighlight ? FontWeight.w600 : FontWeight.w400,
                      color: item.isHighlight ? AppTheme.red : AppTheme.black,
                    ),
                  ),
                ),
                Text(
                  '${item.count}',
                  style: AppStyles.h3.copyWith(
                    color: item.isHighlight ? AppTheme.red : AppTheme.black,
                  ),
                ),
                if (total > 0) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 48,
                    child: Text(
                      '${((item.count / total) * 100).round()}%',
                      textAlign: TextAlign.right,
                      style: AppStyles.caption.copyWith(color: AppTheme.textGray),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.strokeGray),
        ],
      ],
    );
  }
}
