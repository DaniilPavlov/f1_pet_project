import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_loading_widget.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:flutter/material.dart';

/// Скелет списка строк (пикеры, статусы финиша).
class ListRowsShimmer extends StatelessWidget {
  const ListRowsShimmer({
    this.rowCount = 12,
    this.padding,
    this.rowHeight = 44,
    this.rowRadius = 10,
    this.rowGap = 12,
    super.key,
  });

  final int rowCount;
  final EdgeInsetsGeometry? padding;
  final double rowHeight;
  final double rowRadius;
  final double rowGap;

  @override
  Widget build(BuildContext context) {
    final resolvedPadding = padding ??
        const EdgeInsets.symmetric(
          horizontal: StaticData.defaultHorizontalPadding,
          vertical: 12,
        );

    return ScreenShimmer(
      child: ShimmerLoading(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // В bottom sheet высота ограничена — рисуем только то, что влезает,
            // иначе Column overflow (жёлто-чёрные полосы).
            final visibleCount = _visibleRowCount(constraints);
            return Padding(
              padding: resolvedPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < visibleCount; i++)
                    ShimmerSkeleton(height: rowHeight, bottomPadding: rowGap, radius: rowRadius),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  int _visibleRowCount(BoxConstraints constraints) {
    if (!constraints.hasBoundedHeight) {
      return rowCount;
    }
    final pad = padding;
    var verticalPad = 24.0; // default vertical: 12 + 12
    if (pad is EdgeInsets) {
      verticalPad = pad.vertical;
    } else if (pad == EdgeInsets.zero) {
      verticalPad = 0;
    }
    final available = constraints.maxHeight - verticalPad;
    if (available <= 0) {
      return 0;
    }
    final stride = rowHeight + rowGap;
    if (stride <= 0) {
      return rowCount;
    }
    final fits = available ~/ stride;
    if (fits <= 0) {
      return available >= rowHeight ? 1 : 0;
    }
    return fits.clamp(1, rowCount);
  }
}
