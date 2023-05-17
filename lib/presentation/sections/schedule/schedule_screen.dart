import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_calendar.dart';
import 'package:f1_pet_project/presentation/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/presentation/widgets/error_body.dart';
import 'package:f1_pet_project/providers/schedule/schedule_providers.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/anti_glow_behavior.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: Consumer(
          builder: (_, ref, __) {
            final scheduleData = ref.watch(scheduleInitDataProvider);

            return scheduleData.when(
              loading: () => const CustomLoadingIndicator(),
              error: (err, stack) => ErrorBody(
                onTap: () => ref.refresh(scheduleInitDataProvider),
                title: err.toString(),
                subtitle: '',
              ),
              data: (data) => data == null
                  ? ErrorBody(
                      onTap: () => ref.refresh(scheduleInitDataProvider),
                      title: 'Произошла ошибка',
                      subtitle: '',
                    )
                  : const _BodyConsumer(),
            );
          },
        ),
      ),
    );
  }
}

class _BodyConsumer extends ConsumerStatefulWidget {
  const _BodyConsumer({Key? key}) : super(key: key);

  @override
  ConsumerState<_BodyConsumer> createState() => _BodyConsumerState();
}

class _BodyConsumerState extends ConsumerState<_BodyConsumer> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(scheduleSelectedDateProvider);
    final raceWidgets = ref.watch(scheduleRaceWidgetsProvider);
    if (raceWidgets?.isNotEmpty ?? false) {
      animateToSchedule();
    }
    return CustomScrollView(
      controller: controller,
      scrollBehavior: AntiGlowBehavior(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: StaticData.defaultVerticallPadding,
              horizontal: StaticData.defaultHorizontalPadding,
            ),
            child: CustomCalendar(
              imagePathCallback: (value) =>
                  ref.read(scheduleDayLogoProvider(value)),
              onDaySelected: (date1, date2) => onDaySelected(ref, date1),
              selectedDay: selectedDate,
              // focusedDay: wm.focusedDate,
              onPageChanged: (_) {},
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: raceWidgets == null
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: StaticData.defaultVerticallPadding,
                    horizontal: StaticData.defaultHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: raceWidgets,
                  ),
                ),
        ),
      ],
    );
  }

  void onDaySelected(WidgetRef ref, DateTime date) {
    ref
        .read(scheduleRaceWidgetsProvider.notifier)
        .update((state) => ref.read(fetchScheduleOfSelectedDateProvider(date)));
    ref.read(scheduleSelectedDateProvider.notifier).update((state) => date);
  }

  void animateToSchedule() {
    Future<void>.delayed(
      const Duration(milliseconds: 100),
      () => controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeOutCubic,
      ),
    );
  }
}
