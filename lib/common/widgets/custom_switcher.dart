import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Переключатель между двумя вкладками с подчёркиванием.
class CustomSwitcher extends StatelessWidget {
  const CustomSwitcher({
    required this.firstTitle,
    required this.secondTitle,
    required this.onChanged,
    required this.activeValue,
    super.key,
  });
  final String firstTitle;
  final String secondTitle;
  final Function(int) onChanged;
  final int activeValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Tab(title: firstTitle, isActive: activeValue == 0, onTap: () => onChanged(0))),
        Expanded(child: _Tab(title: secondTitle, isActive: activeValue == 1, onTap: () => onChanged(1))),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppTheme.red : AppTheme.pink;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppStyles.h3.copyWith(color: color)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: ColoredBox(
              color: color,
              child: const SizedBox(height: 1, width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
