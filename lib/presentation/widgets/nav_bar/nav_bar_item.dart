import 'package:f1_pet_project/presentation/widgets/nav_bar/custom_bounce_widget.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  const NavBarItem({
    required this.imageAsset,
    required this.title,
    this.isSelected = false,
    this.onPressed,
    super.key,
  });
  final String imageAsset;
  final String title;

  final VoidCallback? onPressed;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return CustomBounceWidget(
      onPressed: () {
        onPressed != null ? onPressed!() : null;
      },
      child: Stack(
        children: [
          Container(
            width: (MediaQuery.of(context).size.width -
                    StaticData.defaultHorizontalPadding * 2) /
                5,
            height: (MediaQuery.of(context).size.width -
                    StaticData.defaultHorizontalPadding * 2) /
                5.5,
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imageAsset,
                  scale: 19.5,
                  color: isSelected ? AppTheme.red : AppTheme.white,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppStyles.navBar.copyWith(
                    color: isSelected ? AppTheme.red : AppTheme.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0),
            height: (MediaQuery.of(context).size.width -
                    StaticData.defaultHorizontalPadding * 2) /
                5.5,
            width: (MediaQuery.of(context).size.width -
                    StaticData.defaultHorizontalPadding * 2) /
                5,
          ),
        ],
      ),
    );
  }
}
