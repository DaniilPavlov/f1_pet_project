import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart';
import 'package:go_router/go_router.dart';

GoRoute scheduleRoute = GoRoute(
  path: '/schedule',
  pageBuilder: (context, state) => const NoTransitionPage<dynamic>(
    child: ScheduleScreen(),
  ),
);
