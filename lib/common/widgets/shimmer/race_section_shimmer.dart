import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет блока последней гонки на Results.
class LastRaceSectionShimmer extends StatelessWidget {
  const LastRaceSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      child: ShimmerLoading(
        child: Padding(
          padding: const EdgeInsets.only(top: StaticData.defaultVerticalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: StaticData.defaultVerticalPadding),
                      child: ShimmerTextLine(height: 18, width: 220, bottomGap: 0),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerTextLine(height: 16, width: 100, bottomGap: 0),
                        ShimmerTextLine(height: 16, width: 80, bottomGap: 0),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < 3; i++) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding, vertical: 6),
                  child: ShimmerSkeleton(height: 36),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Скелет детального экрана гонки: header + race / quali / pits.
class RaceInfoShimmer extends StatelessWidget {
  const RaceInfoShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      child: ShimmerLoading(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            StaticData.defaultHorizontalPadding,
            StaticData.defaultVerticalPadding,
            StaticData.defaultHorizontalPadding,
            StaticData.defaultVerticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerTextLine(height: 20, width: 200, bottomGap: 14),
              const ShimmerTextLine(width: 140, bottomGap: 8),
              const ShimmerTextLine(width: 100, bottomGap: 24),
              _section(titleWidth: 72, rowCount: 8),
              const SizedBox(height: StaticData.defaultVerticalPadding),
              _section(titleWidth: 110, rowCount: 6),
              const SizedBox(height: StaticData.defaultVerticalPadding),
              _section(titleWidth: 90, rowCount: 5),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _section({required double titleWidth, required int rowCount}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerTextLine(height: 16, width: titleWidth, bottomGap: 10),
        const ShimmerSkeleton(height: 28, radius: 4, bottomPadding: 12),
        for (var i = 0; i < rowCount; i++) ...[
          const ShimmerSkeleton(height: 36, bottomPadding: 12),
        ],
      ],
    );
  }
}
