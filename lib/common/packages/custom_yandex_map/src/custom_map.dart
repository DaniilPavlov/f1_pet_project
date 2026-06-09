import 'dart:async';

import 'package:f1_pet_project/common/packages/custom_yandex_map/src/animated_map_pin.dart';
import 'package:f1_pet_project/common/packages/custom_yandex_map/src/controllers/custom_map_controller.dart';
import 'package:f1_pet_project/common/packages/custom_yandex_map/src/map_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CustomMap extends StatefulWidget {
  const CustomMap({
    required this.mapController,
    required this.points,
    this.controller,
    this.userInterface,
    this.onGetUserPositionError,
    this.onPlacemarkPressed,
    this.onMapCreated,
    this.userIcon,
    this.mapObjectIcon,
    this.selectedMapObjectIcon,
    this.clusterColor,
    this.clusterTextStyle,
    this.placemarkIconSize,
    this.selectedPlacemarkIconSize,
    this.onUserPositionStatusUpdated,
    this.onCameraPositionChanged,
    super.key,
  });

  final MapController mapController;
  final List<Point> points;
  final YandexMapController? controller;
  final Widget? userInterface;
  final Function(Exception)? onGetUserPositionError;
  final Function(int)? onPlacemarkPressed;
  final Function(bool)? onUserPositionStatusUpdated;
  final Function(CameraPosition, CameraUpdateReason, bool)? onCameraPositionChanged;
  final Function()? onMapCreated;
  final String? userIcon;
  final String? mapObjectIcon;
  final String? selectedMapObjectIcon;
  final Color? clusterColor;
  final TextStyle? clusterTextStyle;
  final double? placemarkIconSize;
  final double? selectedPlacemarkIconSize;

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  late final CustomMapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomMapController(
      mapController: widget.mapController,
      points: widget.points,
      clusterColor: widget.clusterColor ?? Theme.of(context).primaryColor,
      mapObjectIcon: widget.mapObjectIcon,
      selectedMapObjectIcon: widget.selectedMapObjectIcon,
      userIcon: widget.userIcon,
      placemarkIconSize: widget.placemarkIconSize,
      selectedPlacemarkIconSize: widget.selectedPlacemarkIconSize,
      clusterTextStyle: widget.clusterTextStyle,
    );
  }

  @override
  void didUpdateWidget(CustomMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.updatePoints(widget.points);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<CustomMapController>.value(
      value: _controller,
      child: Observer(
        builder: (context) {
          final controller = context.read<CustomMapController>();
          return Stack(
            children: [
              Listener(
                onPointerDown: (_) => controller.changeIsDraggingState(true),
                onPointerUp: (_) => controller.changeIsDraggingState(false),
                child: YandexMap(
                  mode2DEnabled: true,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  mapObjects: List<MapObject>.from(controller.streamedMapObjects),
                  key: controller.mapKey,
                  onCameraPositionChanged: widget.onCameraPositionChanged,
                  gestureRecognizers: {}..add(
                      const Factory<EagerGestureRecognizer>(
                        EagerGestureRecognizer.new,
                      ),
                    ),
                  onMapCreated: (yandexMapController) async {
                    controller
                      ..controller = yandexMapController
                      ..onGetUserPositionError = widget.onGetUserPositionError
                      ..onPlacemarkPressed = widget.onPlacemarkPressed
                      ..onUserPositionStatusUpdate = widget.onUserPositionStatusUpdated;
                    await Future<void>.delayed(const Duration(seconds: 1));
                    unawaited(controller.init());
                  },
                  logoAlignment: const MapAlignment(
                    horizontal: HorizontalAlignment.left,
                    vertical: VerticalAlignment.bottom,
                  ),
                ),
              ),
              if (widget.userInterface != null) widget.userInterface!,
              if (widget.onCameraPositionChanged != null)
                IgnorePointer(
                  child: Center(
                    child: AnimatedMapPin(
                      isDragging: controller.isDragging,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
