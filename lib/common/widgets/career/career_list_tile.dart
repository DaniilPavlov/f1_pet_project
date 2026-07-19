import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Строка списка на экране карьеры (команда / пилот) с опциональным тапом.
class CareerListTile extends StatelessWidget {
  const CareerListTile({
    required this.title,
    required this.subtitle,
    this.onTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          children: [
            Expanded(child: Text(title, style: AppStyles.body)),
            Text(subtitle, style: AppStyles.body.copyWith(color: AppTheme.textGray)),
          ],
        ),
      ),
    );
  }
}
