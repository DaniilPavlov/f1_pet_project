// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/packages/xpage_map/src/animated_map_pin.dart';
import 'package:f1_pet_project/domain/packages/xpage_map/src/map_controller.dart';
import 'package:f1_pet_project/domain/packages/xpage_map/src/wm/custom_map_wm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CustomMap extends ElementaryWidget<CustomMapWM> {
  final MapController mapController;
  final List<Point> points;
  final YandexMapController? controller;
  final Widget? userInterface;
  final Function(Exception)? onGetUserPositionError;
  final Function(int)? onPlacemarkPressed;
  final Function(bool)? onUserPositionStatusUpdated;
  final Function(CameraPosition, CameraUpdateReason, bool)?
      onCameraPositionChanged;
  final Function()? onMapCreated;
  final String? userIcon;
  final String? mapObjectIcon;
  final String? selectedMapObjectIcon;
  final Color? clusterColor;
  final TextStyle? clusterTextStyle;
  final double? placemarkIconSize;
  final double? selectedPlacemarkIconSize;
  const CustomMap({
    required this.mapController,
    required this.points,
    // required this.dynamicToPointPredecate,
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
    Key? key,
  }) : super(
          createMapWM,
          key: key,
        );

  @override
  Widget build(CustomMapWM wm) {
    return Stack(
      children: [
        StateNotifierBuilder<List<MapObject>>(
          listenableState: wm.streamedMapObjects,
          builder: (context, mapObjects) {
            return Listener(
              onPointerDown: (_) {
                wm.changeIsDraggingState(true);
              },
              onPointerUp: (_) {
                wm.changeIsDraggingState(false);
              },
              child: YandexMap(
                mode2DEnabled: true,
                tiltGesturesEnabled: false,
                rotateGesturesEnabled: false,
                mapObjects: mapObjects ?? [],
                key: wm.mapKey,
                onCameraPositionChanged: onCameraPositionChanged,
                gestureRecognizers: {}..add(
                    const Factory<EagerGestureRecognizer>(
                      EagerGestureRecognizer.new,
                    ),
                  ),
                onMapCreated: (yandexMapController) async {
                  // onMapCreated?.call(yandexMapController);
                  wm
                    ..controller = yandexMapController
                    ..onGetUserPositionError = onGetUserPositionError
                    ..onPlacemarkPressed = onPlacemarkPressed
                    ..onUserPositionStatusUpdate = onUserPositionStatusUpdated;
                  await Future<void>.delayed(const Duration(seconds: 1));
                  unawaited(wm.init());
                },
                logoAlignment: const MapAlignment(
                  horizontal: HorizontalAlignment.left,
                  vertical: VerticalAlignment.bottom,
                ),
              ),
            );
          },
        ),
        if (userInterface != null) userInterface!,
        if (onCameraPositionChanged != null)
          StateNotifierBuilder<bool>(
            listenableState: wm.isDraggingListenable,
            builder: (_, isDragging) {
              return IgnorePointer(
                child: Center(
                  child: AnimatedMapPin(
                    isDragging: isDragging!,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
