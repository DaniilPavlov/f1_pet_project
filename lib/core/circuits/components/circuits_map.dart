import 'package:f1_pet_project/common/widgets/containers/rounded_container.dart';
import 'package:f1_pet_project/core/circuits/components/circuits_map_bottom_sheet.dart';
import 'package:f1_pet_project/core/circuits/models/circuit_model.dart';
import 'package:f1_pet_project/core/map/components/map_container.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CircuitsMap extends StatefulWidget {
  const CircuitsMap({required this.circuits, super.key});

  final List<CircuitModel> circuits;

  @override
  State<CircuitsMap> createState() => _CircuitsMapState();
}

class _CircuitsMapState extends State<CircuitsMap> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final pins = <Point>[];

  @override
  void initState() {
    for (final element in widget.circuits) {
      pins.add(Point(latitude: double.parse(element.location.lat), longitude: double.parse(element.location.long)));
    }

    super.initState();
  }

  Future<void> _openCircuitInfo(int id) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => CircuitsMapBottomSheet(circuit: widget.circuits[id]),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: RoundedContainer(
        contentPadding: const EdgeInsets.all(12),
        child: MapContainer(points: pins, onPlacemarkPressed: _openCircuitInfo),
      ),
    );
  }
}
