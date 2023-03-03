import 'package:extended_image/extended_image.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final String imageAsset;
  final String title;

  final VoidCallback? onPressed;

  final bool isSelected;

  const NavBarItem({
    required this.imageAsset,
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
          height: (MediaQuery.of(context).size.width -
                  StaticData.defaultHorizontalPadding * 2) /
              5,
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExtendedImage.asset(
                imageAsset,
                scale: 15,
                color: isSelected ? AppTheme.red : AppTheme.white,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                title,
                style: AppStyles.navBar.copyWith(
                  color: isSelected ? AppTheme.red : AppTheme.white,
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
