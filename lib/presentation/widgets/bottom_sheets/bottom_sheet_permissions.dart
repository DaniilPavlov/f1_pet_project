import 'package:f1_pet_project/presentation/widgets/bottom_sheets/bottom_sheet_track.dart';
import 'package:f1_pet_project/presentation/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:flutter/material.dart';

class BottomSheetPermissions extends StatelessWidget {
  /// * Виджет для того, чтобы объяснить пользователю зачем нам нужно разрешение.
  const BottomSheetPermissions({
    required this.text,
    required this.onTapSettings,
    super.key,
  });

  /// * Текст описания для чего нужно разрешение.
  final String text;

  /// * Колбек если пользователь хочет перейти в настройки.
  final VoidCallback onTapSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12 * 2 + 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: AppStyles.caption,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: Navigator.of(context).pop,
                              child: ColoredBox(
                                color: Colors.transparent,
                                child: Text(
                                  'не сейчас'.toUpperCase(),
                                  style: AppStyles.body,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: BlackButton(
                              isDisabled: false,
                              onTap: onTapSettings,
                              text: 'Настройки',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: const Center(
                child: BottomSheetTrack(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
