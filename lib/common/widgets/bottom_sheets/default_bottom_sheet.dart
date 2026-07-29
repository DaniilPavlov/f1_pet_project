import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/bottom_sheet_track.dart';
import 'package:flutter/material.dart';

/// Базовый нижний лист с ручкой и телом контента.
class DefaultBottomSheet extends StatelessWidget {
  const DefaultBottomSheet({
    required this.body,
    this.title,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });

  final String? title;

  final Widget body;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12 * 2 + 4),
              Expanded(
                child: Padding(padding: padding, child: body),
              ),
            ],
          ),
          const Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: BottomSheetTrack()),
            ),
          ),
        ],
      ),
    );
  }
}
