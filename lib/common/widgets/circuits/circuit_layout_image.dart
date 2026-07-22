import 'package:f1_pet_project/common/circuits/circuit_layout_assets.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Локальная схема трассы; при отсутствии ассета — ничего не рисует.
class CircuitLayoutImage extends StatelessWidget {
  const CircuitLayoutImage({
    required this.circuitId,
    this.height = 180,
    this.color,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });

  final String circuitId;
  final double height;
  final Color? color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final path = CircuitLayoutAssets.assetPath(circuitId);
    if (path == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Padding(
        padding: padding,
        child: Image.asset(
          path,
          fit: BoxFit.contain,
          color: color ?? AppTheme.black,
          colorBlendMode: BlendMode.srcIn,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}
