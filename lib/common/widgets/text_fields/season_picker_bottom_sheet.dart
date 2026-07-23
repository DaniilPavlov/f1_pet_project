import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/repositories/seasons/seasons_repository.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/controllers/season_picker_sheet_controller/season_picker_sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Bottom sheet со списком сезонов.
class SeasonPickerBottomSheet extends StatelessWidget {
  const SeasonPickerBottomSheet({
    required this.seasonsRepository,
    required this.selectedYear,
    super.key,
  });

  final SeasonsRepository seasonsRepository;
  final String selectedYear;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => SeasonPickerSheetController(seasonsRepository: seasonsRepository)..load(),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.6,
        child: DefaultBottomSheet(
          body: Observer(
            builder: (context) {
              final controller = context.read<SeasonPickerSheetController>();
              if (controller.years.isLoading) {
                return const ListRowsShimmer(rowCount: 10, padding: EdgeInsets.zero);
              }
              if (controller.years.isError || controller.years.value == null) {
                return Center(
                  child: Text(context.l10n.seasonsLoadError, style: AppStyles.body),
                );
              }

              final years = controller.years.value!;
              return ListView.separated(
                itemCount: years.length,
                separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.strokeGray),
                itemBuilder: (context, index) {
                  final year = years[index];
                  final isSelected = year == selectedYear;
                  return ListTile(
                    title: Text(
                      year,
                      style: AppStyles.body.copyWith(
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        color: isSelected ? AppTheme.red : AppTheme.black,
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
      ),
    );
  }
}
