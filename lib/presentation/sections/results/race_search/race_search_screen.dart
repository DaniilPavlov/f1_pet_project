// ignore_for_file: deprecated_member_use

import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/results/race_search/race_search_screen_wm.dart';
import 'package:f1_pet_project/presentation/sections/results/widgets/race_info_table.dart';
import 'package:f1_pet_project/presentation/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/presentation/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/presentation/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RaceSearchScreen extends ElementaryWidget<IRaceSearchScreenWM> {
  const RaceSearchScreen({
    super.key,
  }) : super(createCertainRaceScreenWM);

  @override
  Widget build(IRaceSearchScreenWM wm) {
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
                      onChanged: (_) => wm.checkFields(),
                      keyboardType: TextInputType.number,
                      label: 'Раунд',
                      hintText: 'Номер',
                      controller: wm.roundController,
                    ),
                  ),
                ],
              ),
            ),
            StateNotifierBuilder<bool>(
              listenableState: wm.dataIsLoaded,
              builder: (_, dataIsLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StaticData.defaultHorizontalPadding,
                      ),
                      child: StateNotifierBuilder<bool>(
                        listenableState: wm.fieldsInputted,
                        builder: (_, fieldsInputted) {
                          return dataIsLoaded!
                              ? BlackButton(
                                  isDisabled: !fieldsInputted!,
                                  onTap: wm.loadRaceResults,
                                  text: 'Поиск',
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.red,
                                  ),
                                );
                        },
                      ),
                    ),
                    if (dataIsLoaded! && wm.searchedRace.value!.data != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: StaticData.defaultVerticallPadding,
                        ),
                        child: RaceInfoTable(
                          rowsNumber: 3,
                          results: wm.searchedRace.value!.data!.Results!,
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
