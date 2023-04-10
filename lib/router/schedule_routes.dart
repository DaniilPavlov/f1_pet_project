import 'package:f1_pet_project/presentation/sections/schedule/schedule_screen.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ScheduleRoutes {
  QRoute routes() => QRoute(
        name: 'Schedule',
        path: '/schedule',
        builder: () =>  const ScheduleScreen(),
      );
}
