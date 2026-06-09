import 'package:flutter/material.dart';

/// * Дефолтный закругленный контейнер
class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    required this.child,
    this.borderRadius = 20,
    this.backgroundColor = Colors.white,
    /// * Default EdgeInsets.zero, because Container has it's own padding.
    this.contentPadding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.onTap,
    super.key,
  });
  final Widget child;
  final double? height;
  final double? width;
  final double borderRadius;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final EdgeInsets contentPadding;

  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            margin: margin,
            padding: contentPadding,
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );
  }
}
