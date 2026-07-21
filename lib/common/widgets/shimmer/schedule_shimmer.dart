import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет календаря (сетка + блок сессий).
class ScheduleShimmer extends StatelessWidget {
  const ScheduleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      child: ShimmerLoading(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: StaticData.defaultVerticalPadding,
            horizontal: StaticData.defaultHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ShimmerSkeleton(height: 280, radius: 16),
              const SizedBox(height: StaticData.defaultVerticalPadding),
              const ShimmerTextLine(height: 18, width: 160, bottomGap: 16),
              for (var i = 0; i < 5; i++) ...[
                const ShimmerSkeleton(height: 44, bottomPadding: 12, radius: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
