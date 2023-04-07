import 'package:f1_pet_project/presentation/sections/circuits/circuit/circuit_screen.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';
import 'package:qlevar_router/qlevar_router.dart';

class CircuitRoutes {
  QRoute routes() => QRoute.withChild(
        name: 'Circuits',
        path: 'circuits',
        builderChild: (child) =>  const CircuitsScreen(),
        children: [
          QRoute(
            name: 'Circuit',
            path: '/circuit',
            builder: () => const CircuitScreen(),
          ),
        ],
      );
}
