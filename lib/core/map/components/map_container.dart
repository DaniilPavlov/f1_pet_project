import 'dart:async';

import 'package:f1_pet_project/common/packages/custom_yandex_map/custom_map.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/bottom_sheet_permissions.dart';
import 'package:f1_pet_project/core/map/components/map_controls_widget.dart';
import 'package:f1_pet_project/core/map/controllers/map_container_controller/map_container_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Контейнер с закруглёнными краями и картой внутри.
class MapContainer extends StatefulWidget {
  const MapContainer({
    required this.points,
    this.onAddressChanged,
    this.onPlacemarkPressed,
    this.onCameraPositionChanged,
    super.key,
  });

  final List<Point> points;
  final Function(String)? onAddressChanged;
  final Function(int)? onPlacemarkPressed;
  final Function(double, double)? onCameraPositionChanged;

  @override
  State<MapContainer> createState() => _MapContainerState();
}

/// Состояние карты: разрешения геолокации и жизненный цикл.
class _MapContainerState extends State<MapContainer> with WidgetsBindingObserver {
  late final MapContainerController _controller;
  bool _isRequestPermission = false;
  bool _userPositionExceptionIsShowed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MapContainerController(points: widget.points)..init();
    if (widget.onAddressChanged != null) {
      _controller.mapController.updateUserPosition();
    }
  }

  @override
  void didUpdateWidget(MapContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.updatePoints(widget.points);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isRequestPermission) {
      unawaited(_requestPermission());
      _isRequestPermission = false;
    }
    if (state == AppLifecycleState.paused) {
      _isRequestPermission = true;
    }
  }

  Future<void> _requestPermission() async {
    final geolocationPermission = await Geolocator.requestPermission();
    if (!mounted) return;
    if (geolocationPermission == LocationPermission.denied ||
        geolocationPermission == LocationPermission.deniedForever) {
      unawaited(_openPermissionsSheet());
    }
  }

  void _onGetUserPositionError(Exception ex) {
    if (!_userPositionExceptionIsShowed) {
      Fluttertoast.showToast(msg: ex.toString(), backgroundColor: AppTheme.red);
      _userPositionExceptionIsShowed = true;
    } else {
      unawaited(_openPermissionsSheet());
    }
  }

  Future<void> _openPermissionsSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return BottomSheetPermissions(
          onTapSettings: () async {
            if (await openAppSettings() && sheetContext.mounted) {
              Navigator.of(sheetContext).pop();
            }
          },
          text: 'Приложению требуется доступ к геопозиции.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<MapContainerController>.value(
      value: _controller,
      child: SizedBox(
        height: 327,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomMap(
            mapController: _controller.mapController,
            onPlacemarkPressed: widget.onPlacemarkPressed,
            mapObjectIcon: 'assets/icons/pin_unselected.png',
            selectedMapObjectIcon: 'assets/icons/pin_red.png',
            userIcon: 'assets/icons/location_user.png',
            points: widget.points,
            placemarkIconSize: 1,
            selectedPlacemarkIconSize: 1.2,
            clusterColor: AppTheme.red,
            clusterTextStyle: AppStyles.caption.copyWith(color: Colors.white),
            onGetUserPositionError: _onGetUserPositionError,
            onCameraPositionChanged: widget.onAddressChanged != null
                ? (pos, _, _) => widget.onCameraPositionChanged!(pos.target.latitude, pos.target.longitude)
                : null,
            userInterface: MapControlsWidget(
              onPlusPressed: _controller.mapController.zoomIn,
              onMinusPressed: _controller.mapController.zoomOut,
              onUserLocationPressed: _controller.onUserLocationPressed,
            ),
          ),
        ),
      ),
    );
  }
}
