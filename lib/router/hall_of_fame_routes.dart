import 'package:f1_pet_project/presentation/sections/hall_of_fame/constructors_champions/constructors_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/drivers_champions/drivers_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart';
import 'package:qlevar_router/qlevar_router.dart';

class HallOfFameRoutes {
  QRoute routes() => QRoute.withChild(
        name: 'Hall of fame',
        path: '/hall_of_fame',
        builderChild: (router) =>  HallOfFameScreen(router:router),
        children: [
          QRoute(
            name: 'Drivers champions',
            path: '/drivers_champions',
            builder: () => const DriversChampionsScreen(),
          ),
          QRoute(
            name: 'Constructors champions',
            path: '/constructors_champions',
            builder: () => const ConstructorsChampionsScreen(),
          ),
        ],
      );
}
