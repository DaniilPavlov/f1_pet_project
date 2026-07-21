import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';

/// Выбранная гонка сезона (раунд + отображаемое имя).
class RacePick {
  const RacePick({required this.round, required this.title});

  final String round;
  final String title;
}

/// Read-only поле гонки: список этапов выбранного сезона.
class RacePickerField extends StatelessWidget {
  const RacePickerField({
    required this.displayController,
    required this.seasonYear,
    required this.onPicked,
    this.label,
    this.hintText,
    super.key,
  });

  final TextEditingController displayController;
  final String seasonYear;
  final ValueChanged<RacePick> onPicked;
  final String? label;
  final String? hintText;

  bool get _hasSeason => seasonYear.length == 4;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _hasSeason ? () => _openPicker(context) : null,
      child: AbsorbPointer(
        child: CustomTextField(
          controller: displayController,
          readOnly: true,
          disabled: !_hasSeason,
          label: label ?? context.l10n.race,
          hintText: hintText ?? (_hasSeason ? context.l10n.selectRace : context.l10n.selectSeasonFirst),
          rightWidget: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.expand_more,
              color: _hasSeason ? AppTheme.red : AppTheme.strokeGray,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<RacePick>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RacePickerBottomSheet(
        seasonYear: seasonYear,
        selectedRound: _roundFromDisplay(displayController.text),
      ),
    );

    if (selected == null || !context.mounted) {
      return;
    }
    displayController.text = selected.title;
    onPicked(selected);
  }

  static String? _roundFromDisplay(String display) {
    final dot = display.indexOf('.');
    if (dot <= 0) {
      return null;
    }
    return display.substring(0, dot).trim();
  }
}
