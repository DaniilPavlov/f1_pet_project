import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

final AutoRoute homeRoute = AutoRoute(
  path: 'home',
  page: HomeRouter.page,
  children: [
    AutoRoute(
      path: '',
      page: HomeRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
  ],
);
