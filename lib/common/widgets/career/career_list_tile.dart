import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';

/// Строка списка на экране карьеры (команда / пилот) с опциональным тапом.
class CareerListTile extends StatelessWidget {
  const CareerListTile({
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.accentColor,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          children: [
            if (accentColor != null) ...[
              Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(child: Text(title, style: AppStyles.body)),
            if (trailing != null)
              trailing!
            else if (subtitle != null && subtitle!.isNotEmpty)
              Text(subtitle!, style: AppStyles.body.copyWith(color: context.colors.textGray)),
          ],
        ),
      ),
    );
  }
}
