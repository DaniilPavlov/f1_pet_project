import 'package:f1_pet_project/presentation/widgets/nav_bar/nav_bar_item.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final void Function(int index) onTap;
  final int currentIndex;
  const NavBar({
    required this.onTap,
    required this.currentIndex,
    super.key,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColoredBox(
          color: AppTheme.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: StaticData.defaultHorizontalPadding,
              vertical: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavBarItem(
                  imageAsset: 'assets/nav_bar/home.png',
                  title: 'Главная',
                  isSelected: widget.currentIndex == 0,
                  onPressed: () => widget.onTap(0),
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/racing-car.png',
                  title: 'Результаты',
                  isSelected: widget.currentIndex == 1,
                  onPressed: () => widget.onTap(1),
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/lights.png',
                  title: 'Календарь',
                  isSelected: widget.currentIndex == 2,
                  onPressed: () => widget.onTap(2),
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/trophy.png',
                  title: 'Зал славы',
                  isSelected: widget.currentIndex == 3,
                  onPressed: () => widget.onTap(3),
                ),
                NavBarItem(
                  imageAsset: 'assets/nav_bar/circuit.png',
                  title: 'Трассы',
                  isSelected: widget.currentIndex == 4,
                  onPressed: () => widget.onTap(4),
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
