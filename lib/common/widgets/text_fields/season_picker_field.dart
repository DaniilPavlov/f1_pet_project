import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/season_picker_bottom_sheet.dart';
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
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SeasonPickerBottomSheet(
        seasonsRepository: context.read<SeasonsRepository>(),
        selectedYear: controller.text,
      ),
    );

    if (selected == null || !context.mounted) {
      return;
    }
    controller.text = selected;
    onChanged?.call();
  }
}
