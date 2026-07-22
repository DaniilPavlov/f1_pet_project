import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/widgets/nav_bar/navbar.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

/// Корневой scaffold с нижней навигацией и вкладками.
@RoutePage()
class ScaffoldWithNavBarScreen extends StatelessWidget {
  const ScaffoldWithNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [HomeRouter(), ResultsRouter(), ScheduleRouter(), NewsRouter(), CircuitsRouter()],
      bottomNavigationBuilder: (_, tabsRouter) => NavBar(tabsRouter: tabsRouter),
    );
  }
}
