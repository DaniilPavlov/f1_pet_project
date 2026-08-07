import 'dart:async';

import 'package:f1_pet_project/common/packages/custom_yandex_map/src/animated_map_pin.dart';
import 'package:f1_pet_project/common/packages/custom_yandex_map/src/controllers/custom_map_controller.dart';
import 'package:f1_pet_project/common/packages/custom_yandex_map/src/map_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Виджет Яндекс.Карты с метками, кластерами и геопозицией.
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

/// Состояние виджета карты: создание контроллера и обработка жестов.
class _CustomMapState extends State<CustomMap> {
  late final ProviderContainer _container;

  @override
  void initState() {
    super.initState();
    _container = ProviderContainer(
      overrides: [
        customMapControllerProvider.overrideWith(
          () => CustomMapController(
            mapController: widget.mapController,
            points: widget.points,
            clusterColor: widget.clusterColor ?? Theme.of(context).primaryColor,
            mapObjectIcon: widget.mapObjectIcon,
            selectedMapObjectIcon: widget.selectedMapObjectIcon,
            userIcon: widget.userIcon,
            placemarkIconSize: widget.placemarkIconSize,
            selectedPlacemarkIconSize: widget.selectedPlacemarkIconSize,
            clusterTextStyle: widget.clusterTextStyle,
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(CustomMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Нельзя менять provider state синхронно в didUpdateWidget.
    Future(() {
      if (!mounted) {
        return;
      }
      _container.read(customMapControllerProvider.notifier).updatePoints(widget.points);
    });
  }

  @override
  void dispose() {
    _container.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: _container,
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(customMapControllerProvider);
          final controller = ref.read(customMapControllerProvider.notifier);
          return Stack(
            children: [
              Listener(
                onPointerDown: (_) => controller.changeIsDraggingState(true),
                onPointerUp: (_) => controller.changeIsDraggingState(false),
                child: YandexMap(
                  mode2DEnabled: true,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  mapObjects: List<MapObject>.from(state.streamedMapObjects),
                  key: controller.mapKey,
                  onCameraPositionChanged: widget.onCameraPositionChanged,
                  gestureRecognizers: {}..add(const Factory<EagerGestureRecognizer>(EagerGestureRecognizer.new)),
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
                  child: Center(child: AnimatedMapPin(isDragging: state.isDragging)),
                ),
            ],
          );
        },
      ),
    );
  }
}
