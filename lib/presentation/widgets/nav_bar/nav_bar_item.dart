import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String title;

  final VoidCallback? onPressed;

  final bool isSelected;

  const NavBarItem({
    required this.icon,
    required this.title,
    this.isSelected = false,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: (MediaQuery.of(context).size.width -
                  StaticData.defaultHorizontalPadding * 2) /
              5,
          padding: const EdgeInsets.only(top: 12),
          decoration: isSelected
              ? BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    colors: [
                      AppTheme.red.withOpacity(.6),
                      Colors.red.withOpacity(0),
                    ],
                  ),
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? AppTheme.red : AppTheme.textGray,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: AppStyles.caption.copyWith(
                  color: isSelected ? AppTheme.red : AppTheme.textGray,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            color: Colors.white.withOpacity(0),
            height: 70 - 12,
            width: (MediaQuery.of(context).size.width -
                    StaticData.defaultHorizontalPadding * 2) /
                5,
          ),
        ),
      ],
    );
  }
}
