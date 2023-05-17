// ignore_for_file: deprecated_member_use

import 'package:f1_pet_project/presentation/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchFieldsSection extends StatelessWidget {
  final TextEditingController yearController;
  final TextEditingController roundController;
  final VoidCallback checkFields;
  const SearchFieldsSection({
    required this.yearController,
    required this.roundController,
    required this.checkFields,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: StaticData.defaultHorizontalPadding,
        right: StaticData.defaultHorizontalPadding,
        bottom: StaticData.defaultVerticallPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp('^0+')),
              ],
              keyboardType: TextInputType.number,
              onChanged: (_) => checkFields(),
              toolbarOptions: const ToolbarOptions(
                copy: true,
                selectAll: true,
                cut: true,
              ),
              label: 'Сезон',
              hintText: 'Год',
              controller: yearController,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomTextField(
              toolbarOptions: const ToolbarOptions(
                copy: true,
                selectAll: true,
                cut: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp('^0+')),
              ],
              onChanged: (_) => checkFields(),
              keyboardType: TextInputType.number,
              label: 'Раунд',
              hintText: 'Номер',
              controller: roundController,
            ),
          ),
        ],
      ),
    );
  }
}
