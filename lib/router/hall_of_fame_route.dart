import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/constructors_champions/constructors_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/drivers_champions/drivers_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart';
import 'package:go_router/go_router.dart';

GoRoute hallOfFameRoute = GoRoute(
  path: '/hall_of_fame',
  pageBuilder: (context, state) => const NoTransitionPage<dynamic>(
    child: HallOfFameScreen(),
  ),
  routes: [
    GoRoute(
      path: 'drivers_champions',
      builder: (context, state) => DriversChampionsScreen(
        driversChampions: state.extra as List<StandingsListsModel>,
      ),
    ),
    GoRoute(
      path: 'constructors_champions',
      builder: (context, state) => ConstructorsChampionsScreen(
        constructorsChampions: state.extra as List<StandingsListsModel>,
      ),
    ),
  ],
);
