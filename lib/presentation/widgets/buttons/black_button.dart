import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class BlackButton extends StatelessWidget {
  final Widget? leadIcon;
  final Widget? midIcon;
  final bool haveShadow;
  final VoidCallback onTap;
  final String text;
  final bool isDisabled;
  const BlackButton({
    required this.onTap,
    required this.text,
    required this.isDisabled,
    this.haveShadow = false,
    this.leadIcon,
    this.midIcon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: isDisabled ? () {} : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 17),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isDisabled ? AppTheme.black.withOpacity(0.3) : AppTheme.black,
          borderRadius: BorderRadius.circular(50),
          boxShadow: haveShadow && !isDisabled
              ? [
                  const BoxShadow(
                    offset: Offset(0, 1),
                    color: AppTheme.black,
                    blurRadius: 5.0,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: leadIcon,
              ),
            if (leadIcon != null)
              Text(
                text,
                style: AppStyles.h3.copyWith(
                  color:
                      isDisabled ? AppTheme.red.withOpacity(0.3) : AppTheme.red,
                ),
              )
            else
              Expanded(
                child: midIcon != null
                    ? midIcon!
                    : Text(
                        text,
                        textAlign: TextAlign.center,
                        style: AppStyles.h3.copyWith(
                          color: AppTheme.red,
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
