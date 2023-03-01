import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart';

const scheduleRoute = AutoRoute<dynamic>(
  path: 'schedule',
  page: EmptyRouterScreen,
  name: 'ScheduleRouter',
  children: <AutoRoute>[
    AutoRoute<dynamic>(
      path: '',
      page: ScheduleScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
    // AutoRoute<dynamic>(
    //   path: 'track_schedule',
    //   page: TrackScheduleScreen,
    //   meta: <String, bool>{'hideBottomNav': false},
    // ),
  ],
);
