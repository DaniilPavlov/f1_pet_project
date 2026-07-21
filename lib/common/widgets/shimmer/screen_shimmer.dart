import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Предок для анимации шиммера: владеет sliding-градиентом.
class ScreenShimmer extends StatefulWidget {
  const ScreenShimmer({super.key, this.child, this.colors});

  static ScreenShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ScreenShimmerState>();
  }

  final Widget? child;
  final List<Color>? colors;

  @override
  ScreenShimmerState createState() => ScreenShimmerState();
}

class ScreenShimmerState extends State<ScreenShimmer> with SingleTickerProviderStateMixin {
  Gradient get gradient => LinearGradient(
    colors: widget.colors ?? _shimmerGradient.colors,
    stops: _shimmerGradient.stops,
    begin: _shimmerGradient.begin,
    end: _shimmerGradient.end,
    transform: _SlidingGradientTransform(slidePercent: _shimmerController.value),
  );

  bool get isSized => (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({required RenderBox descendant, Offset offset = Offset.zero}) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  late AnimationController _shimmerController;

  Listenable get shimmerChanges => _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(min: -1.5, max: 10, period: const Duration(milliseconds: 1300));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}

final _shimmerGradient = LinearGradient(
  colors: [AppTheme.shimmerBase, AppTheme.shimmerHighlight, AppTheme.shimmerBase],
  begin: Alignment.bottomRight,
  end: Alignment.centerLeft,
);
