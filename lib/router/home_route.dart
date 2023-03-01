import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';

const homeRoute = AutoRoute<dynamic>(
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
