import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Компактный переключатель из двух опций для блока фильтров H2H.
class H2hFilterToggle extends StatelessWidget {
  const H2hFilterToggle({
    required this.label,
    required this.firstTitle,
    required this.secondTitle,
    required this.activeIndex,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String firstTitle;
  final String secondTitle;
  final int activeIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppStyles.caption.copyWith(color: AppTheme.textGray)),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppTheme.grayBG,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.strokeGray),
          ),
          child: Row(
            children: [
              Expanded(child: _Segment(title: firstTitle, selected: activeIndex == 0, onTap: () => onChanged(0))),
              Expanded(child: _Segment(title: secondTitle, selected: activeIndex == 1, onTap: () => onChanged(1))),
            ],
          ),
        ),
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.title, required this.selected, required this.onTap});

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppTheme.red : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.caption.copyWith(
              color: selected ? AppTheme.white : AppTheme.black,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
