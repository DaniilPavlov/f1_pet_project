import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/presentation/widgets/nav_bar/navbar.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/utils/constants/keys.dart';
import 'package:flutter/material.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      scaffoldKey: Keys.scaffoldKey,
      routes: const [
        HomeRouter(),
        ResultsRouter(),
        ScheduleRouter(),
        HallOfFameRouter(),
        CircuitsRouter(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) => NavBar(
        tabsRouter: tabsRouter,
      ),
    );
  }
}
