import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_field.dart';
import 'package:f1_pet_project/core/results/h2h/components/h2h_filter_toggle.dart';
import 'package:flutter/material.dart';

/// Общий блок фильтров H2H (период / сезон / список участников).
class H2hFiltersCard extends StatelessWidget {
  const H2hFiltersCard({
    required this.scopeMode,
    required this.useCurrentSeason,
    required this.currentEntitiesOnly,
    required this.isSeasonScope,
    required this.showYearPicker,
    required this.latestSeason,
    required this.yearController,
    required this.entitiesFilterLabel,
    required this.currentEntitiesTitle,
    required this.allEntitiesTitle,
    required this.onScopeModeChanged,
    required this.onUseCurrentSeasonChanged,
    required this.onCurrentEntitiesOnlyChanged,
    required this.onSeasonChanged,
    super.key,
  });

  final int scopeMode;
  final bool useCurrentSeason;
  final bool currentEntitiesOnly;
  final bool isSeasonScope;
  final bool showYearPicker;
  final String latestSeason;
  final TextEditingController yearController;
  final String entitiesFilterLabel;
  final String currentEntitiesTitle;
  final String allEntitiesTitle;
  final ValueChanged<int> onScopeModeChanged;
  final ValueChanged<bool> onUseCurrentSeasonChanged;
  final ValueChanged<bool> onCurrentEntitiesOnlyChanged;
  final VoidCallback onSeasonChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.strokeGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.h2hFiltersTitle, style: AppStyles.body.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            H2hFilterToggle(
              label: context.l10n.h2hPeriodFilter,
              firstTitle: context.l10n.careerTitle,
              secondTitle: context.l10n.season,
              activeIndex: scopeMode,
              onChanged: onScopeModeChanged,
            ),
            if (isSeasonScope) ...[
              const SizedBox(height: 14),
              H2hFilterToggle(
                label: context.l10n.h2hSeasonFilter,
                firstTitle: context.l10n.h2hCurrentSeason,
                secondTitle: context.l10n.h2hPickYear,
                activeIndex: useCurrentSeason ? 0 : 1,
                onChanged: (index) => onUseCurrentSeasonChanged(index == 0),
              ),
              if (showYearPicker) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  child: SeasonPickerField(
                    controller: yearController,
                    onChanged: onSeasonChanged,
                  ),
                ),
              ] else if (latestSeason.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  context.l10n.seasonLabel(latestSeason),
                  style: AppStyles.caption.copyWith(color: AppTheme.textGray),
                ),
              ],
            ],
            const SizedBox(height: 14),
            H2hFilterToggle(
              label: entitiesFilterLabel,
              firstTitle: currentEntitiesTitle,
              secondTitle: allEntitiesTitle,
              activeIndex: currentEntitiesOnly ? 0 : 1,
              onChanged: (index) => onCurrentEntitiesOnlyChanged(index == 0),
            ),
          ],
        ),
      ),
    );
  }
}
