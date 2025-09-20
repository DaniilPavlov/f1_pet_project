import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/presentation/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/presentation/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/presentation/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/cupertino.dart';


class CircuitsMapBottomSheet extends StatelessWidget {
  const CircuitsMapBottomSheet({
    required this.circuit,
    super.key,
  });
  final CircuitModel circuit;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      body: Column(
        children: [
          RedBorderContainer(
            title: circuit.circuitName,
            onTap: () async => context.router.navigate(
              CircuitRoute(circuitModel: circuit),
            ),
          ),
          const SizedBox(height: 16),
          BlackButton(
            onTap: () async => context.router.navigate(
              CircuitRoute(circuitModel: circuit),
            ),
            text: 'Подробнее о трассе',
            isDisabled: false,
          ),
        ],
      ),
    );
  }
}
