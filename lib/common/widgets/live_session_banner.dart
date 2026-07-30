import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Баннер «идёт сессия» над bottom nav; тап → Results.
class LiveSessionBanner extends StatelessWidget {
  const LiveSessionBanner({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final live = context.read<LiveWeekendController>();
        if (!live.isLive) {
          return const SizedBox.shrink();
        }
        final abbr = live.liveSessionAbbreviation;
        final label = abbr == null || abbr.isEmpty
            ? context.l10n.liveSessionBanner
            : context.l10n.liveSessionBannerWithSession(abbr);

        return Material(
          color: AppTheme.red,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppStyles.body.copyWith(
                        color: AppTheme.onChrome,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppTheme.onChrome, size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
