import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/helpers/share_helper.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/race_section_shimmer.dart';
import 'package:f1_pet_project/core/results/race_info/components/race_info_scroll_body.dart';
import 'package:f1_pet_project/core/results/race_info/controllers/race_info_screen_controller/race_info_screen_controller.dart';
import 'package:f1_pet_project/core/results/repositories/race_weekend_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Детальный экран гонки: результаты, спринт, квалификация и пит-стопы.
@RoutePage()
class RaceInfoScreen extends StatelessWidget {
  const RaceInfoScreen({required this.raceModel, super.key});

  final RacesModel raceModel;

  @override
  Widget build(BuildContext context) {
    return Provider<RaceInfoScreenController>(
      create: (context) {
        context.read<AnalyticsGateway>().log(
              RaceOpened(
                raceName: raceModel.raceName,
                season: raceModel.season,
                round: raceModel.round,
              ),
            );
        return RaceInfoScreenController(
          raceModel: raceModel,
          scheduleRepository: context.read<ScheduleRepository>(),
          raceWeekendRepository: context.read<RaceWeekendRepository>(),
          dataRefresh: context.read<AppDataRefresh>(),
        )..loadAllData();
      },
      child: Observer(
        builder: (context) {
          final controller = context.read<RaceInfoScreenController>();
          final canShare = controller.allDataIsLoaded && controller.screenError == null;

          return Scaffold(
            appBar: CustomAppBar(
              title: context.l10n.detailedInfo,
              showPreferences: false,
              onPop: () => context.router.maybePop(),
              onShare: canShare
                  ? () => ShareHelper.shareRaceResultsCard(
                      context: context,
                      l10n: context.l10n,
                      race: controller.raceModel,
                    )
                  : null,
            ),
            body: SafeArea(
              child: Builder(
                builder: (context) {
                  if (controller.screenError != null) {
                    return ErrorBody(
                      onTap: controller.refreshAll,
                      title: controller.screenError!.title,
                      subtitle: controller.screenError!.subtitle,
                    );
                  }
                  if (!controller.allDataIsLoaded) {
                    return const RaceInfoShimmer();
                  }

                  return RaceInfoScrollBody(controller: controller);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
