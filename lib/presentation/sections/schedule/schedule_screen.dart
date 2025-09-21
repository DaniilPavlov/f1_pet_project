import 'package:auto_route/auto_route.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/schedule/schedule_screen_wm.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_calendar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ScheduleScreen extends ElementaryWidget<IScheduleScreenWM> {
  const ScheduleScreen({
    super.key,
  }) : super(createScheduleScreenWM);

  @override
  Widget build(IScheduleScreenWM wm) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (wm.screenError.value == null) {
              return dataIsLoaded!
                  ? _Body(wm: wm)
                  : const CustomLoadingIndicator();
            }
            return ErrorBody(
              onTap: wm.loadAllData,
              title: wm.screenError.value!.title,
              subtitle: wm.screenError.value!.subtitle,
            );
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.wm});
  final IScheduleScreenWM wm;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: wm.scrollController,
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        SliverToBoxAdapter(
          child: EntityStateNotifierBuilder<List<RacesModel>>(
            listenableEntityState: wm.racesElements,
            builder: (_, items) {
              return items == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: StaticData.defaultVerticalPadding,
                        horizontal: StaticData.defaultHorizontalPadding,
                      ),
                      child: StateNotifierBuilder<DateTime>(
                        listenableState: wm.selectedDate,
                        builder: (_, selectedDate) => CustomCalendar(
                          imagePathCallback: wm.getLogoPath,
                          onDaySelected: wm.onSelectDay,
                          selectedDay: selectedDate!,
                          onPageChanged: (_) {},
                        ),
                      ),
                    );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: StateNotifierBuilder<List<Widget>>(
            listenableState: wm.scheduleOfSelectedDate,
            builder: (_, items) {
              return items == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: StaticData.defaultVerticalPadding,
                        horizontal: StaticData.defaultHorizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: items,
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
