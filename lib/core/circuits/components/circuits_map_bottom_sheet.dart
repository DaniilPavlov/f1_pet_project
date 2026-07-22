import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/circuits/circuit_layout_assets.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/circuits/circuit_layout_image.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

/// Нижний лист с краткой информацией о трассе на карте.
class CircuitsMapBottomSheet extends StatelessWidget {
  const CircuitsMapBottomSheet({required this.circuit, super.key});
  final CircuitModel circuit;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(circuit.circuitName, style: AppStyles.h2, textAlign: TextAlign.center),
          if (CircuitLayoutAssets.hasLayout(circuit.circuitId)) ...[
            Spacer(),
            CircuitLayoutImage(circuitId: circuit.circuitId, height: 72, padding: EdgeInsets.zero),
          ],
          Spacer(),
          BlackButton(
            onTap: () async => context.router.navigate(CircuitRoute(circuitModel: circuit)),
            text: context.l10n.circuitDetails,
            isDisabled: false,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
