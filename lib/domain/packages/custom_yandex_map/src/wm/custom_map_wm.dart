import 'dart:async';
import 'dart:math';
import 'dart:ui' as dart_ui;
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/domain/packages/custom_yandex_map/src/custom_map.dart';
import 'package:f1_pet_project/domain/packages/custom_yandex_map/src/wm/custom_map_model.dart';
import 'package:f1_pet_project/domain/packages/custom_yandex_map/src/wm/services/geometry_service.dart';
import 'package:f1_pet_project/domain/packages/custom_yandex_map/src/wm/services/camera_services.dart';
import 'package:f1_pet_project/domain/packages/custom_yandex_map/src/wm/services/cluster_drawer.dart';
import 'package:f1_pet_project/domain/packages/custom_yandex_map/src/wm/services/user_position_getter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CustomMapWM extends WidgetModel<CustomMap, CustomMapModel> {
  CustomMapWM(super.model);
  final mapKey = GlobalKey();

  late final onMapCreated = widget.onMapCreated;

  final MapObjectId userMapId = const MapObjectId('user');

  final MapObjectId clusterMapId = const MapObjectId('cluster');

  final animation = const MapAnimation(duration: 0.3);

  late final mapController = widget.mapController;

  final _isDraggingState = StateNotifier<bool>(initValue: false);

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  void Function(int object)? onPlacemarkPressed;

  void Function(Exception exception)? onGetUserPositionError;

  void Function(bool status)? onUserPositionStatusUpdate;

  YandexMapController? controller;

  double userDirection = 0;

  dart_ui.Image? shopMarkerBase;

  StreamSubscription<Position>? userPositionStream;

  Random rng = Random();

  Point? userPosition;

  BitmapDescriptor? mapIcon;

  BitmapDescriptor? selectedMapIcon;

  ListenableState<List<MapObject>> get streamedMapObjects => model.streamedMapObjects;

  ListenableState<bool> get isDraggingListenable => _isDraggingState;

  @override
  Future<void> initWidgetModel() async {
    super.initWidgetModel();

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
        CameraServices.setCenterOn(widget.points, controller: controller);
      }

      if (event.type == 'selectPlacemark') {
        _updateClusterMapObject(widget.points, event.args as int);
      }

      if (event.type == 'moveCameraTo') {
        event.args as List<double>;
        // ignore: avoid_dynamic_calls
        CameraServices.moveTo(Point(latitude: event.args[0] as double, longitude: event.args[1] as double));
      }
    });
  }

  @override
  void dispose() {
    userPositionStream?.cancel();

    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(CustomMap oldWidget) {
    _updateClusterMapObject(widget.points);
    setCenterOn(widget.points);
    super.didUpdateWidget(oldWidget);
  }

  void changeIsDraggingState(bool value) {
    _isDraggingState.accept(value);
  }

  Future<void> init() async {
    if (widget.mapObjectIcon != null) {
      mapIcon ??= BitmapDescriptor.fromAssetImage(widget.mapObjectIcon!);
    }
    if (widget.selectedMapObjectIcon != null) {
      selectedMapIcon ??= BitmapDescriptor.fromAssetImage(widget.selectedMapObjectIcon!);
    }

    await _updateClusterMapObject(widget.points);
    unawaited(setCenterOn(widget.points));
  }

  Future<void> setCenterOn<T>(List<T> newList, {bool withUserPosition = true}) async {
    if (newList.isEmpty) return;
    final list = newList;
    await Future<void>.delayed(const Duration(milliseconds: 100));

    Geometry? geometry;

    geometry = GeometryService.getGeometry(list as List<Point>);

    await Future.delayed(
      const Duration(milliseconds: 100),
      () async =>
          controller?.moveCamera(CameraUpdate.newGeometry(geometry!), animation: const MapAnimation(duration: 0.4)),
    );
  }

  Future<void> _updateClusterMapObject(List<Point> points, [int? indexOfPressedItem]) async {
    model.streamedMapObjects.accept(streamedMapObjects.value?..removeWhere((obj) => obj.mapId == clusterMapId));
    final placemarkCollection = await ClusterDrawer.getCluster(
      clusterMapId: clusterMapId,
      points: points,
      clusterTextStyle: widget.clusterTextStyle,
      selectedPointIndex: indexOfPressedItem,
      placemarkIcon: widget.mapObjectIcon != null
          ? PlacemarkIcon.single(PlacemarkIconStyle(scale: widget.placemarkIconSize ?? 0.5, image: mapIcon!))
          : null,
      selectedPlacemarkIcon: widget.selectedMapObjectIcon != null
          ? PlacemarkIcon.single(
              PlacemarkIconStyle(scale: widget.selectedPlacemarkIconSize ?? 0.5, image: selectedMapIcon!),
            )
          : null,
      clusterColor: widget.clusterColor ?? Theme.of(context).primaryColor,
      onClusterTap: (self, cluster) => CameraServices.setCenterOn(cluster.placemarks, controller: controller),
      onPointTap: (point) async {
        await _updateClusterMapObject(points, point);
        await CameraServices.moveTo(points[point], controller: controller);
        onPlacemarkPressed?.call(point);
      },
    );

    model.streamedMapObjects.accept([...model.streamedMapObjects.value ?? <MapObject>[], placemarkCollection]);
  }

  void _listenUserDirection() {
    if (FlutterCompass.events == null) return;

    _streamSubscriptions.add(
      FlutterCompass.events!.listen((event) {
        if (userPosition == null) return;
        userDirection = event.heading ?? 0;
        final mapObj = [...model.streamedMapObjects.value ?? <MapObject>[]];
        model.streamedMapObjects.accept(
          mapObj..add(
            PlacemarkMapObject(
              mapId: userMapId,
              point: userPosition!,
              opacity: 1,
              direction: userDirection,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  scale: 2,
                  rotationType: RotationType.rotate,
                  image: BitmapDescriptor.fromAssetImage(widget.userIcon!),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _enableListenUserPosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // * onError
        onGetUserPositionError?.call(Exception('Невозможно определить местоположение'));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // * onError
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

CustomMapWM createMapWM(BuildContext _) => CustomMapWM(CustomMapModel());
