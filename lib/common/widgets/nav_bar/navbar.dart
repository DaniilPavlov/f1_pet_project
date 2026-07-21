import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:flutter/material.dart';

/// Нижняя панель навигации приложения.
class NavBar extends StatelessWidget {
  const NavBar({this.tabsRouter, super.key});
  final TabsRouter? tabsRouter;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        Container(
          height: 80 + bottomInset,
          color: AppTheme.black,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              StaticData.defaultHorizontalPadding,
              5,
              StaticData.defaultHorizontalPadding,
              bottomInset,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavBarItem(
                  imageAsset: 'assets/nav_bar/home.png',
                  title: context.l10n.navHome,
                  isSelected: tabsRouter?.activeIndex == 0,
                  onPressed: () {
                    tabsRouter?.setActiveIndex(0);
                  },
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/racing-car.png',
                  title: context.l10n.navResults,
                  isSelected: tabsRouter?.activeIndex == 1,
                  onPressed: () {
                    tabsRouter?.setActiveIndex(1);
                  },
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/lights.png',
                  title: context.l10n.navCalendar,
                  isSelected: tabsRouter?.activeIndex == 2,
                  onPressed: () {
                    tabsRouter?.setActiveIndex(2);
                  },
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/trophy.png',
                  title: context.l10n.navNews,
                  isSelected: tabsRouter?.activeIndex == 3,
                  onPressed: () {
                    tabsRouter?.setActiveIndex(3);
                  },
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/circuit.png',
                  title: context.l10n.navCircuits,
                  isSelected: tabsRouter?.activeIndex == 4,
                  onPressed: () {
                    tabsRouter?.setActiveIndex(4);
                  },
                ),
              ],
            ),
          ),
        ),
        Container(height: 4, color: AppTheme.red),
      ],
    );
  }
}
