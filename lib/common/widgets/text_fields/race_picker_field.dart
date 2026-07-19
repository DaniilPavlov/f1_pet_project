import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/core/results/race_search/loaders/season_races_loader.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/models/schedule_model.dart';
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
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.6,
          child: DefaultBottomSheet(
            body: FutureBuilder<List<RacesModel>>(
              future: _loadRaces(seasonYear),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CustomLoadingIndicator();
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Text(context.l10n.racesLoadError, style: AppStyles.body),
                  );
                }
                final races = snapshot.data!;
                final currentRound = _roundFromDisplay(displayController.text);
                return ListView.separated(
                  itemCount: races.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.strokeGray),
                  itemBuilder: (context, index) {
                    final race = races[index];
                    final title = _titleFor(race);
                    final isSelected = race.round == currentRound;
                    return ListTile(
                      title: Text(
                        title,
                        style: AppStyles.body.copyWith(
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected ? AppTheme.red : AppTheme.black,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: AppTheme.red) : null,
                      onTap: () => Navigator.of(context).pop(RacePick(round: race.round, title: title)),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selected == null || !context.mounted) {
      return;
    }
    displayController.text = selected.title;
    onPicked(selected);
  }

  static Future<List<RacesModel>> _loadRaces(String year) async {
    final response = await SeasonRacesLoader.loadData(year: year);
    final model = ScheduleModel.fromJson(Map<String, dynamic>.from(response.mrData as Map));
    return model.raceTable.races;
  }

  static String _titleFor(RacesModel race) => '${race.round}. ${race.raceName}';

  static String? _roundFromDisplay(String display) {
    final dot = display.indexOf('.');
    if (dot <= 0) {
      return null;
    }
    return display.substring(0, dot).trim();
  }
}
