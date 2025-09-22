import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.image,
    this.onPressed,
    this.borderRadius = 100,
    this.widthRadius = 40,
    this.backgroundColor = AppTheme.red,
    this.iconColor,
    super.key,
  });

  final String image;

  final Color backgroundColor;

  final Color? iconColor;

  final double borderRadius;

  final double widthRadius;

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widthRadius,
      width: widthRadius,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(image, color: AppTheme.white),
          ),
        ),
      ),
    );
  }
}
