import 'package:f1_pet_project/domain/sections/home/tournament_tables/wm/tournament_tables_section_wm.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';

import 'package:flutter/cupertino.dart';

class TablesSwitcher extends StatelessWidget {
  final TournamentTablesSectionWM wm;
  const TablesSwitcher({required this.wm, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => wm.changeActiveTable(value: 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Пилоты',
                      style: wm.activeTable.value == 0
                          ? AppStyles.h2.copyWith(color: AppTheme.red)
                          : AppStyles.h2.copyWith(color: AppTheme.pink),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        height: 1,
                        color: wm.activeTable.value == 0
                            ? AppTheme.red
                            : AppTheme.pink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => wm.changeActiveTable(value: 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Конструкторы',
                      style: wm.activeTable.value == 1
                          ? AppStyles.h2.copyWith(color: AppTheme.red)
                          : AppStyles.h2.copyWith(color: AppTheme.pink),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        height: 1,
                        color: wm.activeTable.value == 1
                            ? AppTheme.red
                            : AppTheme.pink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
