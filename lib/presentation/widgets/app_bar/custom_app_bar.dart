import 'package:beamer/beamer.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:extended_image/extended_image.dart';
import 'package:f1_pet_project/presentation/widgets/buttons/circle_button.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  final VoidCallback? onPop;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  const CustomAppBar({
    this.title,
    this.onPop,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorfulSafeArea(
      color: AppTheme.black,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppTheme.black,
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.withOpacity(0.5),
              blurRadius: 8.0,
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            right: StaticData.defaultHorizontalPadding,
            left: StaticData.defaultHorizontalPadding,
            top: 16,
            bottom: 12,
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onPop != null)
                    CircleButton(
                      child: Transform.translate(
                        offset: const Offset(-1, 0),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        if (Beamer.of(context).canBeamBack) {
                          onPop?.call();
                        }
                      },
                    ),
                ],
              ),
              Center(
                child: title != null
                    ? Text(
                        title!,
                        style: AppStyles.body.copyWith(
                          color: AppTheme.white,
                        ),
                      )
                    : ExtendedImage.asset('assets/app_logo.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
