import 'package:f1_pet_project/presentation/widgets/bottom_sheets/bottom_sheet_track.dart';
import 'package:flutter/material.dart';

class DefaultBottomSheet extends StatelessWidget {
  const DefaultBottomSheet({
    required this.body,
    this.title,
    super.key,
  });

  final String? title;

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12 * 2 + 4),
              Expanded(child: body),
            ],
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Center(
                child: BottomSheetTrack(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
