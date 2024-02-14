import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.size = 40,
    super.key,
  });
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor ?? AppTheme.black,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onPressed,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
