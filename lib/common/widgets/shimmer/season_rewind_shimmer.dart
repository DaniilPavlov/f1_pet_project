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
            if (showScrubber) const _ScrubberShimmer(),
            // CustomSwitcher на экране без боковых отступов.
            const ShimmerSkeleton(height: 52, radius: 0, bottomPadding: 0),
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
                  for (var i = 0; i < 8; i++)
                    _ChartRowShimmer(barFactor: 0.92 - (i * 0.09).clamp(0.0, 0.7)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Как [SeasonRewindScrubber]: название, подпись, play + slider.
class _ScrubberShimmer extends StatelessWidget {
  const _ScrubberShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: StaticData.defaultHorizontalPadding,
        vertical: StaticData.defaultVerticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: ShimmerTextLine(height: 16, width: 180, bottomGap: 4)),
          Center(child: ShimmerTextLine(height: 12, width: 100, bottomGap: 8)),
          Row(
            children: [
              ShimmerSkeleton(height: 36, width: 36, radius: 18),
              SizedBox(width: 8),
              Expanded(child: ShimmerSkeleton(height: 24, radius: 12)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerTextLine(height: 10, width: 48, bottomGap: 0),
              ShimmerTextLine(height: 10, width: 48, bottomGap: 0),
            ],
          ),
        ],
      ),
    );
  }
}

/// Строка как у racing chart: rank + label + bar + points.
class _ChartRowShimmer extends StatelessWidget {
  const _ChartRowShimmer({required this.barFactor});

  final double barFactor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        height: 36,
        child: Row(
          children: [
            const ShimmerSkeleton(height: 14, width: 28, radius: 4),
            const ShimmerSkeleton(height: 14, width: 88, radius: 4),
            const SizedBox(width: 8),
            Expanded(
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: barFactor,
                child: const ShimmerSkeleton(height: 22, radius: 6),
              ),
            ),
            const SizedBox(width: 8),
            const ShimmerSkeleton(height: 14, width: 40, radius: 4),
          ],
        ),
      ),
    );
  }
}
