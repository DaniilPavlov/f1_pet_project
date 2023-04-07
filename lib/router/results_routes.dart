import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuit/circuit_screen.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/constructors_champions/constructors_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/drivers_champions/drivers_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/hall_of_fame_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/race_search_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ResultsRoutes {
  QRoute routes() => QRoute.withChild(
        name: 'Results',
        path: 'results',
        builderChild: (child) => const ResultsScreen(),
        children: [
          QRoute(
            name: 'Race search',
            path: '/race_search',
            builder: () => const RaceSearchScreen(),
          ),
          QRoute(
            name: 'Race info',
            path: '/race_info',
            builder: () => RaceInfoScreen(
              raceModel: QR.params['raceModel']!.valueAs<RacesModel>()!,
            ),
          ),
        ],
      );
}
