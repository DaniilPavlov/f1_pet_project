
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final double? size;
  const CircleButton({
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.size = 40,
    Key? key,
  }) : super(key: key);

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
