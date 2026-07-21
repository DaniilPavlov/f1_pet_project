import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет списка строк (пикеры, H2H, статусы финиша, трассы).
class ListRowsShimmer extends StatelessWidget {
  const ListRowsShimmer({this.rowCount = 12, this.padding, super.key});

  final int rowCount;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      child: ShimmerLoading(
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: StaticData.defaultHorizontalPadding,
                vertical: 12,
              ),
          child: Column(
            children: [
              for (var i = 0; i < rowCount; i++) ...[
                const ShimmerSkeleton(height: 44, bottomPadding: 12, radius: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Скелет экрана трасс: switcher + список.
class CircuitsShimmer extends StatelessWidget {
  const CircuitsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
          child: ScreenShimmer(
            child: ShimmerLoading(
              child: ShimmerSkeleton(height: 40, radius: 10),
            ),
          ),
        ),
        SizedBox(height: 16),
        Expanded(child: SingleChildScrollView(child: ListRowsShimmer())),
      ],
    );
  }
}
