import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RedBorderContainer extends StatelessWidget {
  final String title;
  final TextStyle style;
  final VoidCallback? onTap;
  const RedBorderContainer({
    required this.title,
    this.style = AppStyles.h3,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.red),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: style)),
            if (onTap == null)
              const SizedBox.shrink()
            else
              const Icon(Icons.arrow_right_alt),
          ],
        ),
      ),
    );
  }
}
