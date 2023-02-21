import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:f1_pet_project/presentation/sections/circuits/sections/circuit/circuit_screen.dart';

const homeRoute = AutoRoute<dynamic>(
  maintainState: false,
  path: 'home',
  page: EmptyRouterScreen,
  name: 'HomeRouter',
  children: <AutoRoute>[
    AutoRoute<dynamic>(
      path: '',
      page: HomeScreen,
      meta: <String, bool>{'hideBottomNav': false},
    ),
  ],
);
