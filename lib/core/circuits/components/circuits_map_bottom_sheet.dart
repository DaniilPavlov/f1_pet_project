import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/containers/red_border_container.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      body: Column(
        children: [
          Text(circuit.circuitName, style: AppStyles.h2),
          const SizedBox(height: 16),
          RedBorderContainer(
            title: context.l10n.wikipedia,
            onTap: circuit.url.isEmpty
                ? null
                : () => Utils.openUrl(rawUrl: circuit.url, externalApplication: true),
          ),
          const SizedBox(height: 16),
          BlackButton(
            onTap: () async => context.router.navigate(CircuitRoute(circuitModel: circuit)),
            text: context.l10n.circuitDetails,
            isDisabled: false,
          ),
        ],
      ),
    );
  }
}
