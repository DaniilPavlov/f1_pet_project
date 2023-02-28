import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuits_model.dart';
import 'package:f1_pet_project/router/router.gr.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CircuitElement extends StatelessWidget {
  final CircuitModel circuitModel;
  const CircuitElement({required this.circuitModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () async =>
            context.router.navigate(CircuitRoute(circuitModel: circuitModel)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.red),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Text(circuitModel.circuitName, style: AppStyles.h3),
        ),
      ),
    );
  }
}
