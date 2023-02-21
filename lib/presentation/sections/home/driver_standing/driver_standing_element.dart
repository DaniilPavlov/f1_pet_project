import 'package:f1_pet_project/data/models/sections/home/current_drivers_standings/current_drivers_standings_model.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class DriverStandingElement extends StatelessWidget {
  final DriverStanding driverStandingModel;
  const DriverStandingElement({required this.driverStandingModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.green),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(driverStandingModel.driver.code, style: AppStyles.h3),
      ),
    );
  }
}
