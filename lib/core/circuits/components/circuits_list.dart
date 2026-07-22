import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/circuits/circuit_layout_assets.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/circuits/circuit_layout_image.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

/// Прокручиваемый список трасс с переходом к деталям.
class CircuitsList extends StatefulWidget {
  const CircuitsList({required this.circuits, super.key});
  final List<CircuitModel> circuits;

  @override
  State<CircuitsList> createState() => _CircuitsListState();
}

/// Состояние списка трасс с сохранением вкладки при переключении.
class _CircuitsListState extends State<CircuitsList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      cacheExtent: double.maxFinite,
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final circuit = widget.circuits[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              child: _CircuitListTile(
                circuit: circuit,
                onTap: () async => context.router.navigate(CircuitRoute(circuitModel: circuit)),
              ),
            );
          }, childCount: widget.circuits.length),
        ),
      ],
    );
  }
}

class _CircuitListTile extends StatelessWidget {
  const _CircuitListTile({required this.circuit, required this.onTap});

  final CircuitModel circuit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasLayout = CircuitLayoutAssets.hasLayout(circuit.circuitId);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.red),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Expanded(child: Text(circuit.circuitName, style: AppStyles.h3)),
            if (hasLayout)
              SizedBox(
                width: 72,
                height: 48,
                child: CircuitLayoutImage(circuitId: circuit.circuitId, height: 48, padding: EdgeInsets.zero),
              )
            else
              const Icon(Icons.arrow_right_alt),
          ],
        ),
      ),
    );
  }
}
