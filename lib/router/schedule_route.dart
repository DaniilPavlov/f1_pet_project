import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

final AutoRoute scheduleRoute = AutoRoute(
  path: 'schedule',
  page: ScheduleRouter.page,
  children: [
    AutoRoute(
      path: '',
      page: ScheduleRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
  ],
);
