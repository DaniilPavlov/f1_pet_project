import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/core/results/race_search/controllers/race_search_screen_controller/race_search_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Поля ввода сезона и номера раунда.
class SearchFieldsSection extends StatelessWidget {
  const SearchFieldsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RaceSearchScreenController>();
    return Padding(
      padding: const EdgeInsets.only(
        left: StaticData.defaultHorizontalPadding,
        right: StaticData.defaultHorizontalPadding,
        bottom: StaticData.defaultVerticalPadding,
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
              onChanged: (_) => controller.checkFields(),
              label: 'Сезон',
              hintText: 'Год',
              controller: controller.yearController,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomTextField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp('^0+')),
              ],
              onChanged: (_) => controller.checkFields(),
              keyboardType: TextInputType.number,
              label: 'Раунд',
              hintText: 'Номер',
              controller: controller.roundController,
            ),
          ),
        ],
      ),
    );
  }
}
