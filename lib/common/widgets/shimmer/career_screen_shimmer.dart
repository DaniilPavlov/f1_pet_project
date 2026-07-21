import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет карточки пилота / конструктора.
class CareerScreenShimmer extends StatelessWidget {
  const CareerScreenShimmer({this.showPhoto = true, super.key});

  final bool showPhoto;

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
              if (showPhoto) ...[
                AspectRatio(
                  aspectRatio: 3 / 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppTheme.shimmerBase,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const ShimmerTextLine(height: 24, width: 200, bottomGap: 16),
              const ShimmerTextLine(width: 160),
              const ShimmerTextLine(width: 200),
              const ShimmerTextLine(width: 120, bottomGap: 28),
              const ShimmerTextLine(height: 18, width: 100, bottomGap: 16),
              Row(
                children: [
                  Expanded(child: ShimmerSkeleton(height: 72, radius: 12)),
                  const SizedBox(width: 12),
                  Expanded(child: ShimmerSkeleton(height: 72, radius: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: ShimmerSkeleton(height: 72, radius: 12)),
                  const SizedBox(width: 12),
                  Expanded(child: ShimmerSkeleton(height: 72, radius: 12)),
                ],
              ),
              const SizedBox(height: 28),
              const ShimmerTextLine(height: 18, width: 120, bottomGap: 14),
              for (var i = 0; i < 4; i++) ...[
                const ShimmerSkeleton(height: 44, bottomPadding: 12, radius: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
