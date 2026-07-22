import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/localization/locale_controller.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/custom_calendar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/schedule_shimmer.dart';
import 'package:f1_pet_project/core/schedule/components/schedule_race_featured_card.dart';
import 'package:f1_pet_project/core/schedule/components/schedule_race_sessions_sheet.dart';
import 'package:f1_pet_project/core/schedule/controllers/schedule_screen_controller/schedule_screen_controller.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Экран календаря гонок и расписания сессий сезона.
@RoutePage()
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = context.read<LocaleController>();

    return Observer(
      builder: (context) {
        final localeCode = localeController.locale.languageCode;

        return Provider<ScheduleScreenController>(
          key: ValueKey('schedule_$localeCode'),
          create: (_) => ScheduleScreenController(
            l10n: context.l10n,
            scheduleRepository: context.read<ScheduleRepository>(),
            dataRefresh: context.read<AppDataRefresh>(),
          )..loadAllData(),
          dispose: (_, controller) => controller.dispose(),
          child: Scaffold(
            appBar: const CustomAppBar(),
            body: SafeArea(
              child: Observer(
                builder: (context) {
                  final controller = context.read<ScheduleScreenController>();
                  if (controller.screenError != null) {
                    return ErrorBody(
                      onTap: controller.refreshAll,
                      title: controller.screenError!.title,
                      subtitle: controller.screenError!.subtitle,
                    );
                  }
                  if (!controller.allDataIsLoaded) {
                    return const ScheduleShimmer();
                  }

                  final upcoming = controller.upcomingRace;

                  return RefreshIndicator(
                    color: AppTheme.red,
                    onRefresh: controller.refreshAll,
                    child: CustomScrollView(
                      controller: controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollBehavior: AntiGlowBehavior(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: StaticData.defaultVerticalPadding,
                              horizontal: StaticData.defaultHorizontalPadding,
                            ),
                            child: CustomCalendar(
                              imagePathCallback: controller.getLogoPath,
                              onDaySelected: controller.onSelectDay,
                              selectedDay: controller.selectedDate,
                              onPageChanged: (_) {},
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: StaticData.defaultVerticalPadding,
                              horizontal: StaticData.defaultHorizontalPadding,
                            ),
                            child: controller.selectedDayHasSessions
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: controller.scheduleOfSelectedDate,
                                  )
                                : upcoming == null
                                ? const SizedBox.shrink()
                                : ScheduleRaceFeaturedCard(
                                    race: upcoming,
                                    countdown: controller.upcomingCountdown,
                                    showCountdown: true,
                                    onViewSchedule: () => ScheduleRaceSessionsSheet.show(context, upcoming),
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
      },
    );
  }
}
