import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/presentation/widgets/containers/red_border_container.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

class CircuitsList extends StatefulWidget {
  const CircuitsList({
    required this.circuits,
    super.key,
  });
  final List<CircuitModel> circuits;

  @override
  State<CircuitsList> createState() => _CircuitsListState();
}

class _CircuitsListState extends State<CircuitsList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      cacheExtent: double.maxFinite,
      slivers: [
        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  12,
                  0,
                  12,
                  24,
                ),
                child: RedBorderContainer(
                  title: widget.circuits[index].circuitName,
                  onTap: () async => context.router.navigate(
                    CircuitRoute(circuitModel: widget.circuits[index]),
                  ),
                ),
              );
            },
            childCount: widget.circuits.length,
          ),
        ),
      ],
    );
  }
}
