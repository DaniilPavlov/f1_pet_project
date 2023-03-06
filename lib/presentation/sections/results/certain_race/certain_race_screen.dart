// ignore_for_file: deprecated_member_use

import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/results/certain_race/certain_race_screen_wm.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// TODO(pavlov): доделать поиск
class CertainRaceScreen extends ElementaryWidget<ICertainRaceScreenWM> {
  const CertainRaceScreen({
    super.key,
  }) : super(createCertainRaceScreenWM);

  @override
  Widget build(ICertainRaceScreenWM wm) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Поиск гонки',
        onPop: wm.onPop,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.defaultHorizontalPadding,
                vertical: StaticData.defaultVerticallPadding,
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
                      toolbarOptions: const ToolbarOptions(
                        copy: true,
                        selectAll: true,
                        cut: true,
                      ),
                      label: 'Сезон',
                      hintText: 'Год',
                      controller: wm.yearController,
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
                      keyboardType: TextInputType.number,
                      label: 'Раунд',
                      hintText: 'Номер',
                      controller: wm.roundController,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
