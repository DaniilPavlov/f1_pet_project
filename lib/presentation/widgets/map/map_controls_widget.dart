import 'dart:math' as math;
import 'package:f1_pet_project/presentation/widgets/buttons/custom_icon_button.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class MapControlsWidget extends StatelessWidget {
  const MapControlsWidget({
    this.onPlusPressed,
    this.onMinusPressed,
    this.onUserLocationPressed,
    super.key,
  });

  final VoidCallback? onPlusPressed;
  final VoidCallback? onMinusPressed;
  final VoidCallback? onUserLocationPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 11.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppTheme.red,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onPlusPressed,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onMinusPressed,
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Transform.rotate(
              angle: math.pi / 4,
              child: CustomIconButton(
                image: 'assets/icons/location_user.png',
                onPressed: onUserLocationPressed,
                iconColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
