import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class RedBorderContainer extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const RedBorderContainer({
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.red),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(title, style: AppStyles.h3),
        ),
      ),
    );
  }
}
