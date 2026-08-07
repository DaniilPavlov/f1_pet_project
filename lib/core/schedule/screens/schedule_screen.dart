import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/cached_data_banner.dart';
import 'package:f1_pet_project/common/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/common/widgets/custom_calendar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/on_app_resumed.dart';
import 'package:f1_pet_project/common/widgets/shimmer/schedule_shimmer.dart';
import 'package:f1_pet_project/core/schedule/components/schedule_container.dart';
import 'package:f1_pet_project/core/schedule/components/schedule_race_featured_card.dart';
import 'package:f1_pet_project/core/schedule/components/schedule_race_sessions_sheet.dart';
import 'package:f1_pet_project/core/schedule/controllers/schedule_screen_controller/schedule_screen_controller.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран календаря гонок и расписания сессий сезона.
@RoutePage()
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(scheduleScreenControllerProvider.notifier).loadAllData());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleScreenControllerProvider);
    final controller = ref.read(scheduleScreenControllerProvider.notifier);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: OnAppResumed(
          onResumed: () {
            unawaited(controller.dismissOfflineBannerIfOnline());
          },
          child: Builder(
            builder: (context) {
              if (state.screenError != null) {
                return ErrorBody(
                  onTap: controller.refreshAll,
                  title: state.screenError!.title,
                  subtitle: state.screenError!.subtitle,
                );
              }
              if (!state.allDataIsLoaded) {
                return const ScheduleShimmer();
              }

              final upcoming = state.upcomingRace;

              return RefreshIndicator(
                color: AppTheme.red,
                onRefresh: controller.refreshAll,
                child: CustomScrollView(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollBehavior: AntiGlowBehavior(),
                  slivers: [
                    if (state.showingCachedData)
                      SliverToBoxAdapter(
                        child: CachedDataBanner(message: context.l10n.showingCachedData),
                      ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: StaticData.defaultVerticalPadding,
                          horizontal: StaticData.defaultHorizontalPadding,
                        ),
                        child: CustomCalendar(
                          imagePathCallback: controller.getLogoPath,
                          onDaySelected: controller.onSelectDay,
                          selectedDay: state.selectedDate,
                          focusedDay: state.focusedDate,
                          onPageChanged: controller.onPageChanged,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: StaticData.defaultVerticalPadding,
                          horizontal: StaticData.defaultHorizontalPadding,
                        ),
                        child: state.selectedDayHasSessions
                            ? _SelectedDaySchedule(selectedDay: state.selectedDay)
                            : upcoming == null
                            ? const SizedBox.shrink()
                            : ScheduleRaceFeaturedCard(
                                race: upcoming,
                                countdown: state.upcomingCountdown,
                                showCountdown: true,
                                onViewSchedule: () => ScheduleRaceSessionsSheet.show(context, upcoming),
                              ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          StaticData.defaultHorizontalPadding,
                          12,
                          StaticData.defaultHorizontalPadding,
                          StaticData.defaultVerticalPadding,
                        ),
                        child: RedBorderContainer(
                          title: context.l10n.navCircuits,
                          onTap: () async => context.router.push(const CircuitsRoute()),
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

class _SelectedDaySchedule extends StatelessWidget {
  const _SelectedDaySchedule({required this.selectedDay});

  final ScheduleSelectedDay selectedDay;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectedDay.raceName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: StaticData.defaultHorizontalPadding),
            child: Text(selectedDay.raceName!, style: AppStyles.h3),
          ),
        ...selectedDay.sessions.map(
          (session) => ScheduleContainer(
            title: _sessionTitle(l10n, session.kind),
            date: session.date,
          ),
        ),
      ],
    );
  }

  String _sessionTitle(AppLocalizations l10n, ScheduleSessionKind kind) {
    return switch (kind) {
      ScheduleSessionKind.firstPractice => l10n.firstPractice,
      ScheduleSessionKind.secondPractice => l10n.secondPractice,
      ScheduleSessionKind.thirdPractice => l10n.thirdPractice,
      ScheduleSessionKind.sprintQualifying => l10n.sprintQualifying,
      ScheduleSessionKind.sprint => l10n.sprint,
      ScheduleSessionKind.qualifying => l10n.qualifying,
      ScheduleSessionKind.race => l10n.race,
    };
  }
}
