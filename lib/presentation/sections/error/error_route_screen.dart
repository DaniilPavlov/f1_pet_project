import 'package:f1_pet_project/presentation/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorRouteScreen extends StatelessWidget {
  const ErrorRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.defaultHorizontalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Произошла ошибка при навигации в приложении',
              style: AppStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: StaticData.defaultVerticallPadding),
            BlackButton(
              onTap: () => GoRouter.of(context).go('/home'),
              text: 'Вернуться на главную',
              isDisabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
