import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch scheduleBranch = StatefulShellBranch(
  restorationScopeId: 'branchSchedule',
  routes: <RouteBase>[
    GoRoute(
      path: '/schedule',
      pageBuilder: (context, state) => const NoTransitionPage<dynamic>(
        child: ScheduleScreen(),
      ),
    ),
  ],
);
