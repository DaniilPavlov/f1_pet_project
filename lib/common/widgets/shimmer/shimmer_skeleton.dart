import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Непрозрачный «скелет» — форма для [ShimmerLoading].
class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton({
    required this.height,
    this.radius = 8,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.width,
    this.borderRadius,
    this.color,
    super.key,
  });

  final double radius;
  final double? width;
  final double height;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        right: rightPadding,
        top: topPadding,
        bottom: bottomPadding,
      ),
      child: SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color ?? AppTheme.shimmerBase,
            borderRadius: borderRadius ?? BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}

/// Тонкая строка «текста» с зазором снизу, чтобы линии не слипались.
class ShimmerTextLine extends StatelessWidget {
  const ShimmerTextLine({
    this.width,
    this.height = 12,
    this.bottomGap = 12,
    this.radius = 4,
    super.key,
  });

  final double? width;
  final double height;
  final double bottomGap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      height: height,
      width: width,
      radius: radius,
      bottomPadding: bottomGap,
    );
  }
}
