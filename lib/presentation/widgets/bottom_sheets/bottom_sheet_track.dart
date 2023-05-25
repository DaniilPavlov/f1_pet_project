import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BottomSheetTrack extends StatelessWidget {
  const BottomSheetTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 80,
      decoration: BoxDecoration(
        color: AppTheme.textGray,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
