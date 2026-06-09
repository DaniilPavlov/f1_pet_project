import 'dart:async';

import 'package:f1_pet_project/common/packages/custom_yandex_map/src/map_controller.dart';
import 'package:f1_pet_project/common/packages/custom_yandex_map/src/services/camera_services.dart';
import 'package:f1_pet_project/common/packages/custom_yandex_map/src/services/cluster_drawer.dart';
import 'package:f1_pet_project/common/packages/custom_yandex_map/src/services/geometry_service.dart';
import 'package:f1_pet_project/common/packages/custom_yandex_map/src/services/user_position_getter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'custom_map_controller.g.dart';

class CustomMapController = CustomMapControllerBase with _$CustomMapController;

abstract class CustomMapControllerBase with Store {
  CustomMapControllerBase({
    required this.mapController,
    required this.points,
    required this.clusterColor,
    this.mapObjectIcon,
    this.selectedMapObjectIcon,
    this.userIcon,
    this.placemarkIconSize,
    this.selectedPlacemarkIconSize,
    this.clusterTextStyle,
  }) {
    _listenMapController();
  }

  final MapController mapController;
  List<Point> points;
  final Color clusterColor;
  final String? mapObjectIcon;
  final String? selectedMapObjectIcon;
  final String? userIcon;
  final double? placemarkIconSize;
  final double? selectedPlacemarkIconSize;
  final TextStyle? clusterTextStyle;

  final mapKey = GlobalKey();
  final MapObjectId userMapId = const MapObjectId('user');
  final MapObjectId clusterMapId = const MapObjectId('cluster');
  final animation = const MapAnimation(duration: 0.3);

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  StreamSubscription<Position>? userPositionStream;

  YandexMapController? controller;
  double userDirection = 0;
  Point? userPosition;
  BitmapDescriptor? mapIcon;
  BitmapDescriptor? selectedMapIcon;

  void Function(int object)? onPlacemarkPressed;
  void Function(Exception exception)? onGetUserPositionError;
  void Function(bool status)? onUserPositionStatusUpdate;

  @observable
  ObservableList<MapObject<dynamic>> streamedMapObjects = ObservableList<MapObject<dynamic>>();

  @observable
  bool isDragging = false;

  void dispose() {
    userPositionStream?.cancel();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @action
  void changeIsDraggingState(bool value) {
    isDragging = value;
  }

  @action
  void updatePoints(List<Point> newPoints) {
    points = newPoints;
    unawaited(_updateClusterMapObject(points));
    unawaited(setCenterOn(points));
  }

  void _listenMapController() {
    mapController.stream.listen((event) {
      if (event.type == 'updateUserPosition') {
        _enableListenUserPosition();
        _listenUserDirection();
      }
      if (event.type == 'zoomIn') {
        controller?.moveCamera(CameraUpdate.zoomIn(), animation: animation);
      }
      if (event.type == 'zoomOut') {
        controller?.moveCamera(CameraUpdate.zoomOut(), animation: animation);
      }
      if (event.type == 'center') {
        CameraServices.setCenterOn(points, controller: controller);
      }
      if (event.type == 'selectPlacemark') {
        _updateClusterMapObject(points, event.args as int);
      }
      if (event.type == 'moveCameraTo') {
        final args = event.args! as List<double>;
        CameraServices.moveTo(Point(latitude: args[0], longitude: args[1]));
      }
    });
  }

  @action
  Future<void> init() async {
    if (mapObjectIcon != null) {
      mapIcon ??= BitmapDescriptor.fromAssetImage(mapObjectIcon!);
    }
    if (selectedMapObjectIcon != null) {
      selectedMapIcon ??= BitmapDescriptor.fromAssetImage(selectedMapObjectIcon!);
    }

    await _updateClusterMapObject(points);
    unawaited(setCenterOn(points));
  }

  Future<void> setCenterOn<T>(List<T> newList, {bool withUserPosition = true}) async {
    if (newList.isEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final geometry = GeometryService.getGeometry(newList as List<Point>);

    await Future.delayed(
      const Duration(milliseconds: 100),
      () async => controller?.moveCamera(CameraUpdate.newGeometry(geometry), animation: const MapAnimation(duration: 0.4)),
    );
  }

  Future<void> _updateClusterMapObject(List<Point> mapPoints, [int? indexOfPressedItem]) async {
    final placemarkCollection = await ClusterDrawer.getCluster(
      clusterMapId: clusterMapId,
      points: mapPoints,
      clusterTextStyle: clusterTextStyle,
      selectedPointIndex: indexOfPressedItem,
      placemarkIcon: mapObjectIcon != null
          ? PlacemarkIcon.single(PlacemarkIconStyle(scale: placemarkIconSize ?? 0.5, image: mapIcon!))
          : null,
      selectedPlacemarkIcon: selectedMapObjectIcon != null
          ? PlacemarkIcon.single(
              PlacemarkIconStyle(scale: selectedPlacemarkIconSize ?? 0.5, image: selectedMapIcon!),
            )
          : null,
      clusterColor: clusterColor,
      onClusterTap: (self, cluster) => CameraServices.setCenterOn(cluster.placemarks, controller: controller),
      onPointTap: (point) async {
        await _updateClusterMapObject(mapPoints, point);
        await CameraServices.moveTo(mapPoints[point], controller: controller);
        onPlacemarkPressed?.call(point);
      },
    );

    _setStreamedMapObjects([
      ...streamedMapObjects.where((obj) => obj.mapId != clusterMapId),
      placemarkCollection,
    ]);
  }

  @action
  void _setStreamedMapObjects(List<MapObject<dynamic>> objects) {
    streamedMapObjects = ObservableList.of(objects);
  }

  void _listenUserDirection() {
    if (FlutterCompass.events == null) return;

    _streamSubscriptions.add(
      FlutterCompass.events!.listen((event) {
        if (userPosition == null) return;
        userDirection = event.heading ?? 0;
        _setStreamedMapObjects([
          ...streamedMapObjects.where((obj) => obj.mapId != userMapId),
          PlacemarkMapObject(
            mapId: userMapId,
            point: userPosition!,
            opacity: 1,
            direction: userDirection,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                scale: 2,
                rotationType: RotationType.rotate,
                image: BitmapDescriptor.fromAssetImage(userIcon!),
              ),
            ),
          ),
        ]);
      }),
    );
  }

  Future<void> _enableListenUserPosition() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        onGetUserPositionError?.call(Exception('Невозможно определить местоположение'));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      onGetUserPositionError?.call(Exception('Невозможно определить местоположение'));
    }

    final position = await Geolocator.getCurrentPosition();

    unawaited(
      _updateUserPosition(
        newUserPosition: Point(latitude: position.latitude, longitude: position.longitude),
      ),
    );

    await userPositionStream?.cancel();

    userPositionStream = Geolocator.getPositionStream().listen((position) {
      _updateUserPosition(
        withMoveToUser: false,
        newUserPosition: Point(latitude: position.latitude, longitude: position.longitude),
      );
    });
  }

  Future<void> _updateUserPosition({bool withMoveToUser = true, Point? newUserPosition}) async {
    try {
      userPosition =
          newUserPosition ?? await UserPositionGetter.getUserPosition(onGetUserPositionError: onGetUserPositionError);

      if (withMoveToUser) {
        unawaited(CameraServices.setCenterOn([userPosition!], controller: controller));
      }
    } catch (e) {
      onUserPositionStatusUpdate?.call(false);
    }
  }
}
