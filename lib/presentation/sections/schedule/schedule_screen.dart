// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/schedule/schedule_screen_wm.dart';
import 'package:f1_pet_project/presentation/widgets/custom_calendar.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

// TODO(check): возможно в этом апи учитывается только прошедшее расписание и будущего нет
class ScheduleScreen extends ElementaryWidget<IScheduleScreenWM> {
  const ScheduleScreen({
    super.key,
  }) : super(createScheduleScreenWM);

  @override
  Widget build(IScheduleScreenWM wm) {
    return Scaffold(
      body: SafeArea(
        child: StateNotifierBuilder<bool>(
          listenableState: wm.allDataIsLoaded,
          builder: (_, dataIsLoaded) {
            if (dataIsLoaded != null) {
              return dataIsLoaded
                  ? _Body(wm: wm)
                  : const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.red,
                      ),
                    );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final IScheduleScreenWM wm;
  const _Body({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
                        vertical: 20,
                        horizontal: StaticData.defaultHorizontalPadding,
                      ),
                      child: StateNotifierBuilder<DateTime>(
                        listenableState: wm.selectedDate,
                        builder: (_, selectedDate) => CustomCalendar(
                          imagePathCallback: wm.getLogoPath,
                          onDaySelected: wm.onSelectDay,
                          selectedDay: selectedDate!,
                          // focusedDay: wm.focusedDate,
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
                        vertical: 10,
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
