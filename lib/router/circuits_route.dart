import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuit/circuit_screen.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';

const circuitsRoute = AutoRoute<dynamic>(
  path: 'circuits',
  page: EmptyRouterScreen,
  name: 'CircuitsRouter',
  children: <AutoRoute>[
    AutoRoute<dynamic>(
      path: '',
      page: CircuitsScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute<dynamic>(
      path: 'circuit',
      page: CircuitScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
  ],
);
