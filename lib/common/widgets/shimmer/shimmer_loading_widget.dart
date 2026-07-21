import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:flutter/material.dart';

/// Накладывает sliding-градиент [ScreenShimmer] на дочерние скелетоны.
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({required this.child, this.blendMode = BlendMode.srcATop, super.key});

  final Widget child;
  final BlendMode blendMode;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = ScreenShimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final shimmer = ScreenShimmer.of(context);
    if (shimmer == null || !shimmer.isSized) {
      return widget.child;
    }
    final object = context.findRenderObject();
    if (object is! RenderBox) {
      return widget.child;
    }

    final shimmerSize = shimmer.size;
    final offsetWithinShimmer = shimmer.getDescendantOffset(descendant: object);

    return ShaderMask(
      blendMode: widget.blendMode,
      shaderCallback: (bounds) {
        return shimmer.gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx,
            -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}
