// ignore_for_file: unused_element,member-ordering-extended, avoid_catches_without_on_clauses, library_prefixes, avoid_dynamic_calls, avoid_positional_boolean_parameters

import 'dart:async';
import 'dart:math';
import 'dart:ui' as UI;
import 'dart:ui';

import 'package:elementary/elementary.dart';
import 'package:f1_pet_project/domain/packages/xpage_map/src/custom_map.dart';
import 'package:f1_pet_project/domain/packages/xpage_map/src/wm/custom_map_model.dart';
import 'package:f1_pet_project/domain/packages/xpage_map/src/wm/services/camera_services.dart';
import 'package:f1_pet_project/domain/packages/xpage_map/src/wm/services/cluster_drawer.dart';
import 'package:f1_pet_project/domain/packages/xpage_map/src/wm/services/user_position_getter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as IMG;
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CustomMapWM extends WidgetModel<CustomMap, CustomMapModel> {
  final mapKey = GlobalKey();

  late final onMapCreated = widget.onMapCreated;

  final MapObjectId userMapId = const MapObjectId(
    'user',
  );

  final MapObjectId clusterMapId = const MapObjectId(
    'cluster',
  );

  final animation = const MapAnimation(
    duration: 0.3,
  );

  late final mapController = widget.mapController;

  final _isDraggingState = StateNotifier<bool>(initValue: false);

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  void Function(int object)? onPlacemarkPressed;

  void Function(Exception exception)? onGetUserPositionError;

  void Function(bool status)? onUserPositionStatusUpdate;

  YandexMapController? controller;

  double userDirection = 0;

  UI.Image? shopMarkerBase;

  // late final points = widget.points;

  StreamSubscription<Position>? userPositionStream;

  Random rng = Random();

  Point? userPosition;

  BitmapDescriptor? mapIcon;

  BitmapDescriptor? selectedMapIcon;

  ListenableState<List<MapObject>> get streamedMapObjects =>
      model.streamedMapObjects;

  ListenableState<bool> get isDraggingListenable => _isDraggingState;

  CustomMapWM(super.model);

  @override
  Future<void> initWidgetModel() async {
    super.initWidgetModel();

    mapController.stream.listen(
      (event) {
        if (event.type == 'updateUserPosition') {
          _enableListenUserPosition();
          _listenUserDirection();
        }
        if (event.type == 'zoomIn') {
          controller?.moveCamera(
            CameraUpdate.zoomIn(),
            animation: animation,
          );
        }

        if (event.type == 'zoomOut') {
          controller?.moveCamera(
            CameraUpdate.zoomOut(),
            animation: animation,
          );
        }

        if (event.type == 'center') {
          CameraServices.setCenterOn(
            widget.points,
            controller: controller,
          );
        }

        if (event.type == 'selectPlacemark') {
          _updateClusterMapObject(
            widget.points,
            event.args as int,
          );
        }

        if (event.type == 'moveCameraTo') {
          event.args as List<double>;
          CameraServices.moveTo(
            Point(
              latitude: event.args[0] as double,
              longitude: event.args[1] as double,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    // model.streamedMapObjects.dispose();
    // controller?.dispose();
    userPositionStream?.cancel();

    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(CustomMap oldWidget) {
    _updateClusterMapObject(widget.points);
    // _enableListenUserPosition();
    super.didUpdateWidget(oldWidget);
  }

  void changeIsDraggingState(bool value) {
    _isDraggingState.accept(value);
  }

  Future<void> init() async {
    if (widget.mapObjectIcon != null) {
      mapIcon ??= BitmapDescriptor.fromAssetImage(
        widget.mapObjectIcon!,
      );
    }
    if (widget.selectedMapObjectIcon != null) {
      selectedMapIcon ??= BitmapDescriptor.fromAssetImage(
        widget.selectedMapObjectIcon!,
      );
    }

    await _updateClusterMapObject(widget.points);
    unawaited(setCenterOn(widget.points));
  }

  Future<void> setCenterOn<T>(
    List<T> newList, {
    bool withUserPosition = true,
  }) async {
    if (newList.isEmpty) return;

    final list = newList;
    // debugPrint('list: $list');

    await Future<void>.delayed(
      const Duration(
        milliseconds: 100,
      ),
    );

    BoundingBox? bounds;

    bounds = _getBounds(
      list as List<Point>,
      withUserPosition: withUserPosition,
    );

    await Future.delayed(
      const Duration(
        milliseconds: 100,
      ),
      () async => controller?.moveCamera(
        CameraUpdate.newBounds(bounds!),
        animation: const MapAnimation(
          duration: 0.4,
        ),
      ),
    );
  }

  BoundingBox _getBounds(List<Point> points, {bool withUserPosition = true}) {
    final lngs = points.map<double>((m) => m.longitude).toList();
    final lats = points.map<double>((m) => m.latitude).toList();

    final highestLat = lats.reduce(max);
    final highestLng = lngs.reduce(max);
    final lowestLat = lats.reduce(min);
    final lowestLng = lngs.reduce(min);

    final offset = _calcBoundsOffset(
      highestLat,
      highestLng,
      lowestLat,
      lowestLng,
    );

    return BoundingBox(
      northEast: Point(
        latitude: highestLat + offset,
        longitude: highestLng + offset,
      ),
      southWest: Point(
        latitude: lowestLat - offset,
        longitude: lowestLng - offset,
      ),
    );
  }

  double _calcBoundsOffset(
    double highestLat,
    double highestLng,
    double lowestLat,
    double lowestLng,
  ) {
    final distance = sqrt(
      pow(lowestLat - highestLat, 2) + pow(lowestLng - highestLng, 2),
    );

    // От 0.001 до 1
    return max(
      min(distance / 10, 1),
      0.001,
    );
  }

  Future<void> _updateClusterMapObject(
    List<Point> points, [
    int? indexOfPressedItem,
  ]) async {
    model.streamedMapObjects.accept(
      streamedMapObjects.value
        ?..removeWhere(
          (obj) => obj.mapId == clusterMapId,
        ),
    );

    // final icon = await _rawPlacemarkImage(widget.mapObjectIcon!);

    final placemarkCollection = await ClusterDrawer.getCluster(
      clusterMapId: clusterMapId,
      points: points,
      clusterTextStyle: widget.clusterTextStyle,
      selectedPointIndex: indexOfPressedItem,
      placemarkIcon: widget.mapObjectIcon != null
          ? PlacemarkIcon.single(
              PlacemarkIconStyle(
                scale: widget.placemarkIconSize ?? 0.5,
                image: mapIcon!,
              ),
            )
          : null,
      selectedPlacemarkIcon: widget.selectedMapObjectIcon != null
          ? PlacemarkIcon.single(
              PlacemarkIconStyle(
                scale: widget.selectedPlacemarkIconSize ?? 0.5,
                image: selectedMapIcon!,
              ),
            )
          : null,
      clusterColor: widget.clusterColor ?? Theme.of(context).primaryColor,
      onClusterTap: (self, cluster) => CameraServices.setCenterOn(
        cluster.placemarks,
        controller: controller,
      ),
      onPointTap: (point) async {
        await _updateClusterMapObject(points, point);
        await CameraServices.moveTo(
          points[point],
          controller: controller,
        );
        onPlacemarkPressed?.call(point);
      },
    );

    model.streamedMapObjects.accept(
      [
        ...model.streamedMapObjects.value ?? <MapObject>[],
        placemarkCollection,
      ],
    );
  }

  void _listenUserDirection() {
    if (FlutterCompass.events == null) return;

    _streamSubscriptions.add(
      FlutterCompass.events!.listen(
        (event) {
          if (userPosition == null) return;

          userDirection = event.heading ?? 0;
          final mapObj = [...model.streamedMapObjects.value ?? <MapObject>[]];

          // model.streamedMapObjects.accept(
          //   mapObj
          //     ..removeWhere(
          //       (element) => element.mapId == userMapId,
          //     ),
          // );

          model.streamedMapObjects.accept(
            mapObj
              ..add(
                PlacemarkMapObject(
                  mapId: userMapId,
                  point: userPosition!,
                  opacity: 1,
                  direction: userDirection,
                  icon: PlacemarkIcon.single(
                    PlacemarkIconStyle(
                      scale: 2,
                      rotationType: RotationType.rotate,
                      image: BitmapDescriptor.fromAssetImage(
                        widget.userIcon!,
                      ),
                    ),
                  ),
                ),
              ),
          );
        },
      ),
    );
  }

  Future<void> _enableListenUserPosition() async {
    LocationPermission permission;

    // if (!serviceEnabled) {
    //   // onError
    //   onGetUserPositionError?.call(
    //     Exception(
    //       'Невозможно определить местоположение',
    //     ),
    //   );
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // onError
        onGetUserPositionError?.call(
          Exception(
            'Невозможно определить местоположение',
          ),
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // onError
      onGetUserPositionError?.call(
        Exception(
          'Невозможно определить местоположение',
        ),
      );
    }

    final position = await Geolocator.getCurrentPosition();

    unawaited(_updateUserPosition(
      newUserPosition: Point(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    ));

    await userPositionStream?.cancel();

    userPositionStream = Geolocator.getPositionStream().listen(
      (position) {
        _updateUserPosition(
          withMoveToUser: false,
          newUserPosition: Point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      },
    );
  }

  Future<void> _updateUserPosition({
    bool withMoveToUser = true,
    Point? newUserPosition,
  }) async {
    try {
      // final mapObj = [...model.streamedMapObjects.value ?? <MapObject>[]];
      // model.streamedMapObjects.accept(
      //   mapObj
      //     ..removeWhere(
      //       (element) => element.mapId == userMapId,
      //     ),
      // );

      userPosition = newUserPosition ??
          await UserPositionGetter.getUserPosition(
            onGetUserPositionError: onGetUserPositionError,
          );

      if (withMoveToUser) {
        unawaited(CameraServices.setCenterOn(
          [userPosition!],
          controller: controller,
        ));
      }
    } catch (e) {
      // e as Exception;
      // onGetUserPositionError?.call(e);
      onUserPositionStatusUpdate?.call(false);
    }
  }

  Future<Uint8List> _rawPlacemarkImage(
    String img,
  ) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    const height = 100.0;
    const imageRatio = 1;

    const size = Size(height, height / imageRatio);

    // final imageWidth = size.height * imageRatio;
    shopMarkerBase ??= await _loadUiImage(
      img,
      size: size,
    );

    canvas.drawImage(
      shopMarkerBase!,
      Offset.zero,
      Paint()..color = Colors.red,
    );

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  Future<UI.Image> _loadUiImage(
    String imageAssetPath, {
    required Size size,
  }) async {
    final data = await rootBundle.load(imageAssetPath);

    final image = IMG.decodeImage(data.buffer.asUint8List())!;
    final resized = IMG.copyResize(
      image,
      height: size.height.toInt(),
    );
    final resizedBytes = IMG.encodePng(resized);
    final completer = Completer<UI.Image>();

    UI.decodeImageFromList(
      Uint8List.fromList(resizedBytes),
      completer.complete,
    );
    return completer.future;
  }
}

CustomMapWM createMapWM(BuildContext _) => CustomMapWM(CustomMapModel());
