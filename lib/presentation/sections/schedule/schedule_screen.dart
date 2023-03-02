import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/domain/sections/schedule/schedule_screen_wm.dart';
import 'package:f1_pet_project/presentation/widgets/custom_calendar.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behaviour.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// TODO(pavlov): придумать как обозначить дни гонок
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
        //
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
                      child: CustomCalendar(
                        imagePathCallback: (day) {
                          if (wm.racesElements.value!.data!.any((race) =>
                              isSameDay(DateTime.parse(race.date), day))) {
                            return 'assets/logos/dynamo.png';
                          }
                          return null;
                        },
                        onDaySelected: (selectedDay, focusedDay) {},
                        onPageChanged: (firstDay) {},
                        selectedDay: DateTime.now(),
                      ),

                      ///  Получение логотипа команды оппонента для отображения на календаре
                      // String? getLogoPath(DateTime day) {
                      //   if (matchesOfSelectedMonth.any((match) => isSameDay(match.date, day))) {
                      //     final match = matchesOfSelectedMonth.firstWhere(
                      //       (match) => isSameDay(match.date, day),
                      //     );
                      //     final teams = match.teams;
                      //     return (teams.teamA.id != 1 && teams.teamA.id != 28)
                      //         ? teams.teamA.logo
                      //         : teams.teamB.logo;
                      //   }
                      //   return null;
                      // }

                      // child: ListView.builder(
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: items.length,
                      //   shrinkWrap: true,
                      //   itemBuilder: (context, index) => Padding(
                      //     padding: const EdgeInsets.only(bottom: 20),
                      //     child: RedBorderContainer(
                      //       title: items[index].raceName,
                      //       // onTap: () async => context.router.navigate(
                      //       //   CircuitRoute(circuitModel: items[index]),
                      //       // ),),
                      //       onTap: () {},
                      //     ),
                      //   ),
                      // ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
