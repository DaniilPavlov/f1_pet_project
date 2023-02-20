import 'package:f1_pet_project/data/models/sections/home/circuits/circuits_model.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:f1_pet_project/utils/utils.dart';
import 'package:flutter/material.dart';

class CircuitElement extends StatelessWidget {
  final CircuitModel circuitModel;
  const CircuitElement({required this.circuitModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => Utils.ULaunchUrl(rawUrl: circuitModel.url),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: AppTheme.red),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Text(circuitModel.circuitName, style: AppStyles.h3),
        ),
      ),
    );
  }
}
