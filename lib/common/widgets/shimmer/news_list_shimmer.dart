import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет ленты новостей.
class NewsListShimmer extends StatelessWidget {
  const NewsListShimmer({this.itemCount = 4, super.key});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ScreenShimmer(
      child: ShimmerLoading(
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            StaticData.defaultHorizontalPadding,
            12,
            StaticData.defaultHorizontalPadding,
            StaticData.defaultVerticalPadding,
          ),
          itemCount: itemCount,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, _) => Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.strokeGray),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            clipBehavior: Clip.hardEdge,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ColoredBox(color: AppTheme.shimmerBase),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerTextLine(height: 16, width: 220, bottomGap: 14),
                      ShimmerTextLine(),
                      ShimmerTextLine(width: 180),
                      ShimmerTextLine(height: 10, width: 100, bottomGap: 0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
