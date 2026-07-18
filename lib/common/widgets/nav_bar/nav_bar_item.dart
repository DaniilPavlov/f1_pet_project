import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/nav_bar/bounce_animation_widget.dart';
import 'package:flutter/material.dart';

/// Элемент нижней навигации с иконкой и подписью.
class NavBarItem extends StatelessWidget {
  const NavBarItem({required this.imageAsset, required this.title, this.isSelected = false, this.onPressed, super.key});

  final String imageAsset;
  final String title;
  final VoidCallback? onPressed;
  final bool isSelected;

  static const _iconSize = 28.0;

  /// Масштаб обрезки краевого мата PNG, который иначе даёт квадратную обводку после tint.
  static const _edgeCropScale = 1.12;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppTheme.red : AppTheme.white;
    final itemWidth = (MediaQuery.sizeOf(context).width - StaticData.defaultHorizontalPadding * 2) / 5;

    return BounceAnimationWidget(
      onPressed: () => onPressed?.call(),
      isSelected: isSelected,
      child: SizedBox(
        width: itemWidth,
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: _iconSize,
                height: _iconSize,
                child: ClipRect(
                  child: Transform.scale(
                    scale: _edgeCropScale,
                    child: Image.asset(
                      imageAsset,
                      width: _iconSize,
                      height: _iconSize,
                      fit: BoxFit.contain,
                      color: color,
                      colorBlendMode: BlendMode.srcIn,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppStyles.navBar.copyWith(color: color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
