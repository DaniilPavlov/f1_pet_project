import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/core/seasons/repositories/seasons_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Read-only поле сезона: открывает список годов из Jolpica `seasons/`.
class SeasonPickerField extends StatelessWidget {
  const SeasonPickerField({
    required this.controller,
    this.onChanged,
    this.label,
    this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final VoidCallback? onChanged;
  final String? label;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openPicker(context),
      child: AbsorbPointer(
        child: CustomTextField(
          controller: controller,
          readOnly: true,
          label: label ?? context.l10n.season,
          hintText: hintText ?? context.l10n.selectSeason,
          rightWidget: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.expand_more, color: AppTheme.red, size: 22),
          ),
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final repository = context.read<SeasonsRepository>();
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.6,
          child: DefaultBottomSheet(
            body: FutureBuilder<List<String>>(
              future: repository.getSeasonYears(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CustomLoadingIndicator();
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return Center(
                    child: Text(context.l10n.seasonsLoadError, style: AppStyles.body),
                  );
                }
                final years = snapshot.data!;
                final current = controller.text;
                return ListView.separated(
                  itemCount: years.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.strokeGray),
                  itemBuilder: (context, index) {
                    final year = years[index];
                    final isSelected = year == current;
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
        );
      },
    );

    if (selected == null || !context.mounted) {
      return;
    }
    controller.text = selected;
    onChanged?.call();
  }
}
