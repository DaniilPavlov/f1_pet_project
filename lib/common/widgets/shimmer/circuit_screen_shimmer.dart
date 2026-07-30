import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет экрана трассы: схема, stats-ряд, локация, список побед.
class CircuitScreenShimmer extends StatelessWidget {
  const CircuitScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      child: ShimmerLoading(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.defaultHorizontalPadding,
            vertical: StaticData.defaultVerticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.shimmerBase,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const ShimmerTextLine(height: 24, width: 220, bottomGap: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: context.colors.strokeGray),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: const Row(
                  children: [
                    Expanded(child: _StatSkeleton()),
                    SizedBox(width: 8),
                    Expanded(child: _StatSkeleton()),
                    SizedBox(width: 8),
                    Expanded(child: _StatSkeleton()),
                    SizedBox(width: 8),
                    Expanded(child: _StatSkeleton()),
                    SizedBox(width: 8),
                    Expanded(child: _StatSkeleton()),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const ShimmerTextLine(width: 140, bottomGap: 16),
              const ShimmerTextLine(height: 18, width: 160, bottomGap: 10),
              const ShimmerTextLine(height: 18, width: 140, bottomGap: 28),
              const ShimmerTextLine(height: 20, width: 140, bottomGap: 12),
              for (var i = 0; i < 4; i++) ...[
                const ShimmerSkeleton(height: 44, bottomPadding: 12, radius: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatSkeleton extends StatelessWidget {
  const _StatSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShimmerSkeleton(height: 14, radius: 4),
        SizedBox(height: 6),
        ShimmerSkeleton(height: 10, width: 36, radius: 4),
      ],
    );
  }
}
