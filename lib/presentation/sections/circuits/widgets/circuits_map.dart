import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/presentation/widgets/containers/rounded_container.dart';
import 'package:f1_pet_project/presentation/widgets/map/map_container.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CircuitsMap extends StatefulWidget {
  const CircuitsMap({
    required this.circuits,
    required this.openCircuitInfo,
    super.key,
  });
  final List<CircuitModel> circuits;
  final Function(int id) openCircuitInfo;

  @override
  State<CircuitsMap> createState() => _CircuitsMapState();
}

class _CircuitsMapState extends State<CircuitsMap>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final pins = <Point>[];

  @override
  void initState() {
    for (final element in widget.circuits) {
      pins.add(
        Point(
          latitude: double.parse(element.location.lat),
          longitude: double.parse(element.location.long),
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: RoundedContainer(
        contentPadding: const EdgeInsets.all(12),
        child: MapContainer(
          points: pins,
          onPlacemarkPressed: widget.openCircuitInfo,
        ),
      ),
    );
  }
}
