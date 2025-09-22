import 'package:f1_pet_project/domain/sections/results/race_search/race_search_screen_wm.dart';
import 'package:f1_pet_project/presentation/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchFieldsSection extends StatelessWidget {
  const SearchFieldsSection({required this.wm, super.key});
  final IRaceSearchScreenWM wm;

  @override
  Widget build(BuildContext context) {
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
              onChanged: (_) => wm.checkFields(),

              label: 'Сезон',
              hintText: 'Год',
              controller: wm.yearController,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomTextField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp('^0+')),
              ],
              onChanged: (_) => wm.checkFields(),
              keyboardType: TextInputType.number,
              label: 'Раунд',
              hintText: 'Номер',
              controller: wm.roundController,
            ),
          ),
        ],
      ),
    );
  }
}
