import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.twistingDots(
        leftDotColor: AppTheme.black,
        rightDotColor: AppTheme.red,
        size: 100,
      ),
    );
  }
}
