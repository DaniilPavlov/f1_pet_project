import 'package:f1_pet_project/providers/home/home_providers.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TablesSwitcherConsumer extends ConsumerWidget {
  const TablesSwitcherConsumer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTable = ref.watch(homeActiveTableProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    ref.read(homeActiveTableProvider.notifier).state = 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Пилоты',
                      style: activeTable == 0
                          ? AppStyles.h2.copyWith(color: AppTheme.red)
                          : AppStyles.h2.copyWith(color: AppTheme.pink),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        height: 1,
                        color: activeTable == 0 ? AppTheme.red : AppTheme.pink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    ref.read(homeActiveTableProvider.notifier).state = 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Конструкторы',
                      style: activeTable == 1
                          ? AppStyles.h2.copyWith(color: AppTheme.red)
                          : AppStyles.h2.copyWith(color: AppTheme.pink),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        height: 1,
                        color: activeTable == 1 ? AppTheme.red : AppTheme.pink,
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
