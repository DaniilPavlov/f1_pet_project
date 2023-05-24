import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/presentation/widgets/nav_bar/nav_bar_item.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final TabsRouter? tabsRouter;

  const NavBar({
    this.tabsRouter,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 90,
          color: AppTheme.black,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              StaticData.defaultHorizontalPadding,
              5,
              StaticData.defaultHorizontalPadding,
              // MediaQuery.of(context).viewPadding.bottom == 0
              //     ? 12
              //     : MediaQuery.of(context).viewPadding.bottom,
              5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavBarItem(
                  imageAsset: 'assets/nav_bar/home.png',
                  title: 'Главная',
                  isSelected: tabsRouter?.activeIndex == 0,
                  onPressed: () {
                    tabsRouter?.setActiveIndex(0);
                  },
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/racing-car.png',
                  title: 'Результаты',
                  isSelected: tabsRouter?.activeIndex == 1,
                  onPressed: () {
                    tabsRouter?.setActiveIndex(1);
                  },
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/lights.png',
                  title: 'Календарь',
                  isSelected: tabsRouter?.activeIndex == 2,
                  onPressed: () {
                    tabsRouter?.setActiveIndex(2);
                  },
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/trophy.png',
                  title: 'Зал славы',
                  isSelected: tabsRouter?.activeIndex == 3,
                  onPressed: () {
                    tabsRouter?.setActiveIndex(3);
                  },
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/circuit.png',
                  title: 'Трассы',
                  isSelected: tabsRouter?.activeIndex == 4,
                  onPressed: () {
                    tabsRouter?.setActiveIndex(4);
                  },
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 4,
          color: AppTheme.red,
        ),
      ],
    );
  }
}
