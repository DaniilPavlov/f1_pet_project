import 'package:extended_image/extended_image.dart';
import 'package:f1_pet_project/presentation/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';

class ErrorBody extends StatelessWidget {
  final VoidCallback onTap;
  final String? title;
  final String? subtitle;
  final bool withImage;
  const ErrorBody({
    required this.onTap,
    required this.title,
    required this.subtitle,
    this.withImage = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: StaticData.defaultVerticallPadding,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 4,
            right: MediaQuery.of(context).size.width / 4,
            bottom: 10,
          ),
          child: ExtendedImage.asset(
            'assets/error_car.png',
            height: MediaQuery.of(context).size.height / 3.6,
            width: MediaQuery.of(context).size.width / 2.7,
            fit: BoxFit.fill,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title ?? 'Соединение отсутствует',
            maxLines: 3,
            style: AppStyles.h2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 20,
            left: 20,
            right: 20,
          ),
          child: Text(
            subtitle ??
                'Как только соединение восстановится, вы снова сможете пользоваться приложением',
            style: AppStyles.h3,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          child: BlackButton(
            haveShadow: true,
            onTap: onTap,
            text: 'Обновить',
            isDisabled: false,
          ),
        ),
      ]),
    );
  }
}
