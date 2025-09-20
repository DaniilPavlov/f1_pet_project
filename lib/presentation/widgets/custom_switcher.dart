import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

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
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    firstTitle,
                    style: activeValue == 0
                        ? AppStyles.h3.copyWith(color: AppTheme.red)
                        : AppStyles.h3.copyWith(color: AppTheme.pink),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      height: 1,
                      color: activeValue == 0 ? AppTheme.red : AppTheme.pink,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    secondTitle,
                    style: activeValue == 1
                        ? AppStyles.h3.copyWith(color: AppTheme.red)
                        : AppStyles.h3.copyWith(color: AppTheme.pink),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Container(
                      height: 1,
                      color: activeValue == 1 ? AppTheme.red : AppTheme.pink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
