import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет карточки уикенда — размеры как у [_ScoreboardCard].
class WeekendScoreboardShimmer extends StatelessWidget {
  const WeekendScoreboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.strokeGray),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // shortName + status chip
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: ShimmerSkeleton(height: 24, radius: 4)),
              SizedBox(width: 8),
              ShimmerSkeleton(height: 24, width: 72),
            ],
          ),
          // circuitName (body)
          const SizedBox(height: 8),
          const ShimmerSkeleton(height: 20, width: 220, radius: 4),
          // location row
          const SizedBox(height: 6),
          const Row(
            children: [
              ShimmerSkeleton(height: 20, width: 28, radius: 4),
              SizedBox(width: 8),
              Expanded(child: ShimmerSkeleton(height: 14, radius: 4)),
            ],
          ),
          // highlighted session card
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.shimmerBase, borderRadius: BorderRadius.circular(12)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ShimmerSkeleton(height: 20, width: 48, radius: 4, color: AppTheme.shimmerHighlight),
                    ),
                    ShimmerSkeleton(height: 20, width: 20, radius: 4, color: AppTheme.shimmerHighlight),
                  ],
                ),
                SizedBox(height: 4),
                ShimmerSkeleton(height: 14, width: 140, radius: 4, color: AppTheme.shimmerHighlight),
                SizedBox(height: 6),
                ShimmerSkeleton(height: 20, width: 200, radius: 4, color: AppTheme.shimmerHighlight),
              ],
            ),
          ),
          // sessions list (типичный уикенд: 5 сессий)
          const SizedBox(height: 14),
          for (var i = 0; i < 5; i++) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  ShimmerSkeleton(height: 14, width: 48, radius: 4),
                  SizedBox(width: 8),
                  Expanded(child: ShimmerSkeleton(height: 14, radius: 4)),
                  SizedBox(width: 8),
                  ShimmerSkeleton(height: 14, width: 56, radius: 4),
                  SizedBox(width: 4),
                  ShimmerSkeleton(height: 16, width: 16, radius: 4),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Заголовок секции + карточка с теми же отступами, что у контента.
class WeekendScoreboardSectionShimmer extends StatelessWidget {
  const WeekendScoreboardSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        StaticData.defaultHorizontalPadding,
        StaticData.defaultVerticalPadding,
        StaticData.defaultHorizontalPadding,
        0,
      ),
      child: ScreenShimmer(
        child: ShimmerLoading(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppStyles.h1 = 34
              ShimmerSkeleton(height: 34, width: 160, radius: 4),
              SizedBox(height: 16),
              WeekendScoreboardShimmer(),
            ],
          ),
        ),
      ),
    );
  }
}
