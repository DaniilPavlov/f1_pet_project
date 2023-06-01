import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:go_router/go_router.dart';

GoRoute homeRoute = GoRoute(
  path: '/home',
  pageBuilder: (context, state) => const NoTransitionPage<dynamic>(
    child: HomeScreen(),
  ),
);
