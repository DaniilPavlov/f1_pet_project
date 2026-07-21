import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет турнирных таблиц (Home / Hall of Fame).
class TournamentTablesShimmer extends StatelessWidget {
  const TournamentTablesShimmer({this.showHeader = true, super.key});

  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      child: ShimmerLoading(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHeader) ...[
                const SizedBox(height: StaticData.defaultVerticalPadding),
                const ShimmerTextLine(height: 24, width: 180, bottomGap: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerTextLine(height: 16, width: 100, bottomGap: 0),
                    ShimmerTextLine(height: 16, width: 80, bottomGap: 0),
                  ],
                ),
                const SizedBox(height: 24),
              ],
              const ShimmerSkeleton(height: 40, radius: 10, bottomPadding: 16),
              for (var i = 0; i < 10; i++) ...[
                const ShimmerSkeleton(height: 40, bottomPadding: 12, radius: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
