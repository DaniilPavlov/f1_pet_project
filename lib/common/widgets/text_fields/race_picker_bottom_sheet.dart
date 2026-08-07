import 'dart:async';

import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/controllers/race_picker_sheet_controller/race_picker_sheet_controller.dart';
import 'package:f1_pet_project/common/widgets/text_fields/race_picker_field.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom sheet со списком гонок сезона.
class RacePickerBottomSheet extends ConsumerStatefulWidget {
  const RacePickerBottomSheet({
    required this.seasonYear,
    required this.selectedRound,
    super.key,
  });

  final String seasonYear;
  final String? selectedRound;

  @override
  ConsumerState<RacePickerBottomSheet> createState() => _RacePickerBottomSheetState();
}

class _RacePickerBottomSheetState extends ConsumerState<RacePickerBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(ref.read(racePickerSheetControllerProvider(widget.seasonYear).notifier).load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(racePickerSheetControllerProvider(widget.seasonYear));

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: DefaultBottomSheet(
        body: Builder(
          builder: (context) {
            if (state.races.isLoading) {
              return const ListRowsShimmer(rowCount: 10, padding: EdgeInsets.zero);
            }
            if (state.races.isError || state.races.value == null) {
              return Center(
                child: Text(context.l10n.racesLoadError, style: AppStyles.body),
              );
            }

            final races = state.races.value!;
            return ListView.separated(
              itemCount: races.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: context.colors.strokeGray),
              itemBuilder: (context, index) {
                final race = races[index];
                final title = _titleFor(race);
                final isSelected = race.round == widget.selectedRound;
                return ListTile(
                  title: Text(
                    title,
                    style: AppStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected ? AppTheme.red : context.colors.black,
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
  }

  static String _titleFor(RacesModel race) => '${race.round}. ${race.raceName}';
}
