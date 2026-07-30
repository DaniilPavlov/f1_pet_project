import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет результата H2H: заголовок графика, chart, легенда, compare-строки.
class H2hCompareShimmer extends StatelessWidget {
  const H2hCompareShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerTextLine(height: 12, width: 80, bottomGap: 12),
            const ShimmerTextLine(height: 16, width: 160, bottomGap: 8),
            const ShimmerTextLine(height: 12, width: 200, bottomGap: 16),
            const ShimmerSkeleton(height: 220, radius: 12, bottomPadding: 12),
            const Row(
              children: [
                ShimmerSkeleton(height: 10, width: 10, radius: 5),
                SizedBox(width: 8),
                Expanded(child: ShimmerSkeleton(height: 12, radius: 4)),
                SizedBox(width: 16),
                ShimmerSkeleton(height: 10, width: 10, radius: 5),
                SizedBox(width: 8),
                Expanded(child: ShimmerSkeleton(height: 12, radius: 4)),
              ],
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                SizedBox(width: 100),
                Expanded(child: ShimmerSkeleton(height: 16, radius: 4)),
                SizedBox(width: 12),
                Expanded(child: ShimmerSkeleton(height: 16, radius: 4)),
              ],
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < 4; i++) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    ShimmerSkeleton(height: 12, width: 80, radius: 4),
                    SizedBox(width: 20),
                    Expanded(child: ShimmerSkeleton(height: 22, radius: 4)),
                    SizedBox(width: 12),
                    Expanded(child: ShimmerSkeleton(height: 22, radius: 4)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
