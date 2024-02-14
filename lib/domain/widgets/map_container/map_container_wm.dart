// ignore_for_file: depend_on_referenced_packages, avoid_dynamic_calls

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
// import 'package:yandex_geocoder/yandex_geocoder.dart' as yg;
import 'package:yandex_mapkit/yandex_mapkit.dart' as ym;

class MapContainerWM extends WidgetModel<MapContainer, MapContainerModel>
    with WidgetsBindingObserver, AutomaticKeepAliveWidgetModelMixin {
  MapContainerWM(super.model);
  final mapController = MapController();

  List<ym.Point> listPoint = <ym.Point>[];

  late StateNotifier<List<ym.Point>> listPointState =
      StateNotifier<List<ym.Point>>(initValue: widget.points);
  Function deepEq = const DeepCollectionEquality().equals;

  bool isRequestPermission = false;
  bool userPositionExceptionIsShowed = false;

  // Timer? _debounce;

  // final geocoder = yg.YandexGeocoder(
  //   apiKey: StaticData.yandexGeocoderApiKey,
  // );

  @override
  void didUpdateWidget(MapContainer oldWidget) {
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
    if (state == AppLifecycleState.resumed && isRequestPermission == true) {
      /// Проверяем разрешение, если приложение продолжило работать и если можно проверить разрешения
      requestPermission();
      isRequestPermission = false;
    }
    if (state == AppLifecycleState.paused) {
      /// При паузе приложения разрешаем проверку разрешений
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
      Fluttertoast.showToast(
        msg: ex.toString(),
        // msg: 'Соединение отсутствует',
        backgroundColor: AppTheme.red,
      );
      userPositionExceptionIsShowed = true;
    } else {
      openBottomSheetPermissionsLocation();
    }
  }

  void onUserLocationPressed() {
    mapController.updateUserPosition();
  }

  Future<void> onCameraPositionChanged(
    ym.CameraPosition pos,
    ym.CameraUpdateReason reason,
    bool _,
  ) async {
    await widget.onCameraPositionChanged!
        .call(pos.target.latitude, pos.target.longitude);

    // try {
    //   // получаю строку по координатам
    //   if (_debounce?.isActive ?? false) _debounce!.cancel();

    //   _debounce = Timer(
    //     const Duration(milliseconds: 500),
    //     () async {
    //       final geocodeFromPoint = await geocoder.getGeocode(
    //         yg.GeocodeRequest(
    //           geocode: yg.PointGeocode(
    //             latitude: pos.target.latitude,
    //             longitude: pos.target.longitude,
    //           ),
    //           lang: yg.Lang.ru,
    //         ),
    //       );

    //       final _comp = geocodeFromPoint.firstAddress?.components;

    //       if (_comp?.isNotEmpty ?? false) {
    //         final _address =
    //             '${getComponentName(_comp!, 3)}${getComponentName(_comp, 2)}${_comp.last.name}';

    //         widget.onAndressChanged?.call(_address);
    //       }
    //     },
    //   );
    // } catch (e) {
    //   debugPrint('$e');
    // }
  }

  Future<void> openBottomSheetPermissionsLocation() async {
    await openBottomSheetPermissions(
      text: 'Приложению требуется доступ к геопозиции.',
    );
  }

  Future<void> openBottomSheetPermissions({required String text}) async {
    await showModalBottomSheet<Widget>(
      context: context,
      builder: (context) {
        return BottomSheetPermissions(
          onTapSettings: () async {
            if (await openAppSettings() == true) {
              // isRequestPermission = true;
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            }
          },
          text: text,
        );
      },
    );
  }

  // String? getComponentName(List<yg.Component> components, int indexFromEnd) {
  //   if (components.length - indexFromEnd >= 0) {
  //     final name = components[components.length - indexFromEnd].name;
  //     return '$name, ';
  //   }
  //   return null;
  // }
}

MapContainerWM createMapContainerWM(BuildContext _) =>
    MapContainerWM(MapContainerModel());
