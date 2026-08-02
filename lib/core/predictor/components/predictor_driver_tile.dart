import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';

/// Строка пилота в reorderable-списке предиктора.
class PredictorDriverTile extends StatelessWidget {
  const PredictorDriverTile({
    required this.index,
    required this.driver,
    required this.enabled,
    super.key,
  });

  final int index;
  final DriverModel driver;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final mutedColor = enabled ? context.colors.black : context.colors.textGray;

    return Material(
      color: context.colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: SizedBox(
          width: 28,
          child: Text(
            '${index + 1}',
            style: AppStyles.body.copyWith(
              fontFamily: 'HelveticaNeueCyr-Bold',
              color: mutedColor,
            ),
          ),
        ),
        title: Text(
          '${driver.givenName} ${driver.familyName}',
          style: AppStyles.body.copyWith(color: mutedColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          driver.code ?? '',
          style: AppStyles.caption.copyWith(color: context.colors.textGray),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: enabled
            ? ReorderableDragStartListener(
                index: index,
                child: Icon(Icons.drag_handle, color: context.colors.textGray),
              )
            : const Icon(Icons.lock_outline, size: 18, color: AppTheme.pink),
      ),
    );
  }
}
