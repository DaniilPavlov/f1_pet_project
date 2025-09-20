import 'package:f1_pet_project/presentation/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';

class InfoMessageSection extends StatelessWidget {
  const InfoMessageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:const EdgeInsets.symmetric(
        horizontal: StaticData.defaultHorizontalPadding,
        vertical: StaticData.defaultVerticalPadding,
      ),
      child: RedBorderContainer(
        title:
            'Здесь вы можете найти результаты определенной гонки, начиная с 1950 года.\nМинимальное количество раундов в сезоне - 7, максимальное - 24.\n(данные на момент 2025 года)',
        style: AppStyles.body.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
