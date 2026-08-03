import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constructor_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';

/// Строка пилота в reorderable-списке предиктора.
class PredictorDriverTile extends StatelessWidget {
  const PredictorDriverTile({
    required this.index,
    required this.driver,
    required this.enabled,
    this.constructor,
    this.onTap,
    super.key,
  });

  final int index;
  final DriverModel driver;
  final bool enabled;
  final ConstructorModel? constructor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final teamColor = constructor != null
        ? ConstructorColors.forConstructorId(constructor!.constructorId)
        : const Color(0xFF5A5A5A);
    final bg = enabled ? teamColor : teamColor.withValues(alpha: 0.45);
    final onTeam = teamColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    final onTeamMuted = onTeam.withValues(alpha: enabled ? 0.85 : 0.7);
    final subtitle = constructor?.name ?? driver.code ?? '';
    final name = '${driver.givenName} ${driver.familyName}'.trim();

    return Semantics(
      button: enabled,
      label: context.l10n.predictorDriverSemantics(
        index + 1,
        name,
        enabled ? '' : context.l10n.predictorLockedSuffix,
      ),
      child: ExcludeSemantics(
        child: Material(
          color: bg,
          child: ListTile(
            onTap: enabled ? onTap : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            leading: SizedBox(
              width: 28,
              child: Text(
                '${index + 1}',
                style: AppStyles.body.copyWith(
                  fontFamily: 'HelveticaNeueCyr-Bold',
                  color: onTeam,
                ),
              ),
            ),
            title: Text(
              name,
              style: AppStyles.body.copyWith(
                color: onTeam,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              subtitle,
              style: AppStyles.caption.copyWith(color: onTeamMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: enabled
                ? ReorderableDragStartListener(
                    index: index,
                    child: Icon(Icons.drag_handle, color: onTeamMuted),
                  )
                : Icon(Icons.lock_outline, size: 18, color: onTeamMuted),
          ),
        ),
      ),
    );
  }
}
