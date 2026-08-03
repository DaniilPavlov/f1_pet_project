import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/nav_bar/bounce_animation_widget.dart';
import 'package:flutter/material.dart';

/// Элемент нижней навигации с иконкой и подписью.
class NavBarItem extends StatelessWidget {
  const NavBarItem({
    required this.title,
    this.imageAsset,
    this.icon,
    this.isSelected = false,
    this.onPressed,
    this.iconSize = _defaultIconSize,
    this.edgeCropScale = _defaultEdgeCropScale,
    super.key,
  }) : assert(imageAsset != null || icon != null, 'Provide imageAsset or icon');

  final String? imageAsset;
  final IconData? icon;
  final String title;
  final VoidCallback? onPressed;
  final bool isSelected;

  /// Размер слота иконки.
  final double iconSize;

  /// Масштаб обрезки краевого мата PNG (tint иначе даёт квадратную обводку).
  final double edgeCropScale;

  static const _defaultIconSize = 28.0;

  /// Zoom-in под ClipRect, чтобы срезать полупрозрачный мат по краям PNG.
  static const _defaultEdgeCropScale = 1.12;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppTheme.red : AppTheme.onChrome;
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
                width: iconSize,
                height: iconSize,
                child: icon != null
                    ? Icon(icon, size: iconSize * 0.9, color: color)
                    : ClipRect(
                        child: Transform.scale(
                          scale: edgeCropScale,
                          child: Image.asset(
                            imageAsset!,
                            width: iconSize,
                            height: iconSize,
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
