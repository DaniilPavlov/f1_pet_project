import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/widgets/live_session_banner.dart';
import 'package:f1_pet_project/common/widgets/nav_bar/navbar.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

/// Корневой scaffold с нижней навигацией и вкладками.
///
/// Meta `hideBottomNav: true` на вложенном маршруте скрывает баннер + NavBar
/// (например экраны входа / регистрации в Profile).
@RoutePage()
class ScaffoldWithNavBarScreen extends StatelessWidget {
  const ScaffoldWithNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      homeIndex: 0,
      routes: const [
        HomeRouter(),
        ResultsRouter(),
        ScheduleRouter(),
        NewsRouter(),
        ProfileRouter(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return ListenableBuilder(
          listenable: tabsRouter,
          builder: (context, _) {
            final hideNav = tabsRouter.topRoute.meta['hideBottomNav'] == true;
            if (hideNav) {
              return const SizedBox.shrink();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LiveSessionBanner(onTap: () => tabsRouter.setActiveIndex(1)),
                NavBar(tabsRouter: tabsRouter),
              ],
            );
          },
        );
      },
    );
  }
}
