import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/presentation/widgets/nav_bar/nav_bar_item.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
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
          height: 1,
          color: AppTheme.strokeGray,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            StaticData.defaultPadding,
            0,
            StaticData.defaultPadding,
            MediaQuery.of(context).viewPadding.bottom == 0
                ? 12
                : MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavBarItem(
                icon: Icons.house_sharp,
                title: 'Главная',
                isSelected: tabsRouter?.activeIndex == 0,
                onPressed: () {
                  tabsRouter?.setActiveIndex(0);
                },
              ),
              NavBarItem(
                icon: Icons.house_sharp,
                title: 'Трассы',
                isSelected: tabsRouter?.activeIndex == 1,
                onPressed: () {
                  tabsRouter?.setActiveIndex(1);
                },
              ),
              // NavBarItem(
              //   icon: Icons.house_sharp,
              //   title: 'Билеты',
              //   isSelected: tabsRouter?.activeIndex == 2,
              //   onPressed: () {
              //     tabsRouter?.setActiveIndex(2);
              //   },
              // ),
              // NavBarItem(
              //   icon: Icons.house_sharp,
              //   title: 'Матчи',
              //   isSelected: tabsRouter?.activeIndex == 3,
              //   onPressed: () {
              //     tabsRouter?.setActiveIndex(3);
              //   },
              // ),
              // NavBarItem(
              //   icon: Icons.house_sharp,
              //   title: 'Команда',
              //   isSelected: tabsRouter?.activeIndex == 4,
              //   onPressed: () {
              //     tabsRouter?.setActiveIndex(4);
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
