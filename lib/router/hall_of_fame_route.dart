import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/constructors_champions/constructors_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/drivers_champions/drivers_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart';

const hallOfFameRoute = AutoRoute<dynamic>(
  path: 'hall_of_fame',
  page: EmptyRouterScreen,
  name: 'HallOfFameRouter',
  children: <AutoRoute>[
    AutoRoute<dynamic>(
      path: '',
      page: HallOfFameScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute<dynamic>(
      path: 'drivers_champions',
      page: DriversChampionsScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute<dynamic>(
      path: 'constructors_champions',
      page: ConstructorsChampionsScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
  ],
);
