import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/sections/results/certain_race/certain_race_screen_wm.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:flutter/material.dart';

// TODO(pavlov): сделать поиск
class CertainRaceScreen extends ElementaryWidget<ICertainRaceScreenWM> {
  const CertainRaceScreen({
    super.key,
  }) : super(createCertainRaceScreenWM);

  @override
  Widget build(ICertainRaceScreenWM wm) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: StaticData.defaultHorizontalPadding,
              ),
              child: Text(
                'Поиск гонки',
                style: AppStyles.h1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
