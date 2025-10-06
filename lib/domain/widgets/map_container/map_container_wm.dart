import 'dart:async';
import 'package:collection/collection.dart';
import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/domain/packages/custom_yandex_map/src/map_controller.dart';
import 'package:f1_pet_project/domain/widgets/map_container/map_container_model.dart';
import 'package:f1_pet_project/presentation/widgets/bottom_sheets/bottom_sheet_permissions.dart';
import 'package:f1_pet_project/presentation/widgets/map/map_container.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;

class MapContainerWM extends WidgetModel<MapContainer, MapContainerModel>
    with WidgetsBindingObserver, AutomaticKeepAliveWidgetModelMixin {
  MapContainerWM(super._model);
  final mapController = MapController();

  List<ym.Point> listPoint = <ym.Point>[];

  late StateNotifier<List<ym.Point>> listPointState = StateNotifier<List<ym.Point>>(initValue: widget.points);
  Function deepEq = const DeepCollectionEquality().equals;

  bool isRequestPermission = false;
  bool userPositionExceptionIsShowed = false;

  @override
  void didUpdateWidget(MapContainer oldWidget) {
    // ignore: avoid_dynamic_calls
    if (deepEq(oldWidget.points, widget.points) == false) {
      listPointState.accept(widget.points);
      super.didUpdateWidget(oldWidget);
    }
  }

  @override
  void initWidgetModel() {
    if (widget.onAndressChanged != null) {
      mapController.updateUserPosition();
    }

    super.initWidgetModel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isRequestPermission) {
      // * Проверяем разрешение, если приложение продолжило работать и если можно проверить разрешения
      requestPermission();
      isRequestPermission = false;
    }
    if (state == AppLifecycleState.paused) {
      // * При паузе приложения разрешаем проверку разрешений
      isRequestPermission = true;
    }
  }

  Future<void> requestPermission() async {
    final geolocationPermission = await Geolocator.requestPermission();
    if (geolocationPermission == LocationPermission.denied ||
        geolocationPermission == LocationPermission.deniedForever) {
      unawaited(openBottomSheetPermissionsLocation());
    }
  }

  void onGetUserPositionError(Exception ex) {
    if (!userPositionExceptionIsShowed) {
      Fluttertoast.showToast(msg: ex.toString(), backgroundColor: AppTheme.red);
      userPositionExceptionIsShowed = true;
    } else {
      openBottomSheetPermissionsLocation();
    }
  }

  void onUserLocationPressed() {
    mapController.updateUserPosition();
  }

  Future<void> onCameraPositionChanged(ym.CameraPosition pos, ym.CameraUpdateReason reason, bool _) async {
    await widget.onCameraPositionChanged!.call(pos.target.latitude, pos.target.longitude);
  }

  Future<void> openBottomSheetPermissionsLocation() async {
    await openBottomSheetPermissions(text: 'Приложению требуется доступ к геопозиции.');
  }

  Future<void> openBottomSheetPermissions({required String text}) async {
    await showModalBottomSheet<Widget>(
      context: context,
      builder: (context) {
        return BottomSheetPermissions(
          onTapSettings: () async {
            if (await openAppSettings() && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          text: text,
        );
      },
    );
  }
}

MapContainerWM createMapContainerWM(BuildContext _) => MapContainerWM(MapContainerModel());
