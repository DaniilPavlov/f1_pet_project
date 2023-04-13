import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/constructors_champions/constructors_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/hall_of_fame/drivers_champions/drivers_champions_screen.dart';
import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:go_router/go_router.dart';

GoRoute homeRoute = GoRoute(
  path: '/home',
  pageBuilder: (context, state) => const NoTransitionPage<dynamic>(
    child: HomeScreen(),
  ),
);
