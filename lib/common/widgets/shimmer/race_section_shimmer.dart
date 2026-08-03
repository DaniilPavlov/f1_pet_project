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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: StaticData.defaultVerticalPadding,
                  left: StaticData.defaultHorizontalPadding,
                  right: StaticData.defaultHorizontalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ShimmerTextLine(height: 20, width: 200, bottomGap: 0),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: StaticData.defaultVerticalPadding),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerTextLine(height: 20, width: 110, bottomGap: 0),
                          ShimmerTextLine(height: 20, width: 90, bottomGap: 0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _section(rowCount: 8),
              const SizedBox(height: StaticData.defaultVerticalPadding),
              _section(rowCount: 6),
              const SizedBox(height: StaticData.defaultVerticalPadding),
              _section(rowCount: 5),
              const SizedBox(height: StaticData.defaultVerticalPadding),
            ],
          ),
        ),
      ),
    );
  }

  /// Секция как на экране: full-bleed шапка + строки таблицы без боковых отступов.
  static Widget _section({required int rowCount}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ShimmerSkeleton(height: 40, radius: 0, bottomPadding: 0),
        const ShimmerSkeleton(height: 32, radius: 0, bottomPadding: 0),
        for (var i = 0; i < rowCount; i++)
          const ShimmerSkeleton(height: 36, radius: 0, bottomPadding: 1),
      ],
    );
  }
}
