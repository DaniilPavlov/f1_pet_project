import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/presentation/widgets/scaffold_with_navbar.dart';
import 'package:f1_pet_project/router/home_route.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen|Page,Route',
  routes: <AutoRoute>[
    AutoRoute<dynamic>(
      path: '/',
      page: CustomScaffoldWithNavBar,
      initial: true,
      children: [
        homeRoute,
      ],
    ),
  ],
)
class $AppRouter {}