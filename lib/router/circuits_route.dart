import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuit/circuit_screen.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';
import 'package:go_router/go_router.dart';

GoRoute circuitsRoute = GoRoute(
  path: '/circuits',
  pageBuilder: (context, state) => const NoTransitionPage<dynamic>(
    child: CircuitsScreen(),
  ),
  routes: [
    GoRoute(
      path: 'circuit',
      builder: (context, state) =>
          CircuitScreen(circuitModel: state.extra as CircuitModel),
    ),
  ],
);
