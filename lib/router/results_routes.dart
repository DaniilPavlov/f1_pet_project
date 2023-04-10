import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/presentation/sections/results/race_info/race_info_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/race_search/race_search_screen.dart';
import 'package:f1_pet_project/presentation/sections/results/results_screen.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ResultsRoutes {
  QRoute routes() => QRoute.withChild(
        name: 'Results',
        path: '/results',
        builderChild: (router) =>  ResultsScreen(router:router),
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
