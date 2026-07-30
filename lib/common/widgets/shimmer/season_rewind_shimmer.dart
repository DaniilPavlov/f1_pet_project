import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет Season Rewind: scrubber + switcher + racing bars.
class SeasonRewindShimmer extends StatelessWidget {
  const SeasonRewindShimmer({this.showScrubber = true, super.key});

  /// При `false` — только chart (когда scrubber уже на экране).
  final bool showScrubber;

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      child: ShimmerLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showScrubber)
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: StaticData.defaultHorizontalPadding,
                  vertical: StaticData.defaultVerticalPadding,
                ),
                child: Column(
                  children: [
                    ShimmerTextLine(height: 16, width: 180, bottomGap: 8),
                    ShimmerTextLine(height: 12, width: 100, bottomGap: 12),
                    ShimmerSkeleton(height: 32, radius: 16),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShimmerSkeleton(height: 40, width: 40, radius: 20),
                      ],
                    ),
                  ],
                ),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
              child: ShimmerSkeleton(height: 40, radius: 10, bottomPadding: 16),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.defaultHorizontalPadding,
                0,
                StaticData.defaultHorizontalPadding,
                StaticData.defaultVerticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerTextLine(height: 12, width: 160, bottomGap: 12),
                  for (var i = 0; i < 8; i++) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const ShimmerSkeleton(height: 28, width: 28, radius: 14),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.85 - (i * 0.08).clamp(0.0, 0.55),
                              child: const ShimmerSkeleton(height: 28, radius: 8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const ShimmerSkeleton(height: 14, width: 36, radius: 4),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
