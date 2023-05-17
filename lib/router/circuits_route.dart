import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

final AutoRoute circuitsRoute = AutoRoute(
  path: 'circuits',
  page: CircuitsRouter.page,
  children: [
    AutoRoute(
      path: '',
      page: CircuitsRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute(
      path: 'circuit',
      page: CircuitRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
  ],
);
