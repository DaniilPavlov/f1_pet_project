import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/presentation/widgets/nav_bar/navbar.dart';
import 'package:f1_pet_project/router/router.gr.dart';
import 'package:f1_pet_project/utils/constants/keys.dart';
import 'package:flutter/material.dart';

class CustomScaffoldWithNavBar extends StatelessWidget {
  const CustomScaffoldWithNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      scaffoldKey: Keys.scaffoldKey,
      routes: const [
        HomeRouter(),
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
