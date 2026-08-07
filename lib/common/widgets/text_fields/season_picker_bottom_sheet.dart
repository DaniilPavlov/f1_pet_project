import 'dart:async';

import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/controllers/season_picker_sheet_controller/season_picker_sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom sheet со списком сезонов.
class SeasonPickerBottomSheet extends ConsumerStatefulWidget {
  const SeasonPickerBottomSheet({
    required this.selectedYear,
    super.key,
  });

  final String selectedYear;

  @override
  ConsumerState<SeasonPickerBottomSheet> createState() => _SeasonPickerBottomSheetState();
}

class _SeasonPickerBottomSheetState extends ConsumerState<SeasonPickerBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(ref.read(seasonPickerSheetControllerProvider.notifier).load());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seasonPickerSheetControllerProvider);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: DefaultBottomSheet(
        body: Builder(
          builder: (context) {
            if (state.years.isLoading) {
              return const ListRowsShimmer(rowCount: 10, padding: EdgeInsets.zero);
            }
            if (state.years.isError || state.years.value == null) {
              return Center(
                child: Text(context.l10n.seasonsLoadError, style: AppStyles.body),
              );
            }

            final years = state.years.value!;
            return ListView.separated(
              itemCount: years.length,
              separatorBuilder: (_, _) => Divider(height: 1, color: context.colors.strokeGray),
              itemBuilder: (context, index) {
                final year = years[index];
                final isSelected = year == widget.selectedYear;
                return ListTile(
                  title: Text(
                    year,
                    style: AppStyles.body.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected ? AppTheme.red : context.colors.black,
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: AppTheme.red) : null,
                  onTap: () => Navigator.of(context).pop(year),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
