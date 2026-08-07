import 'dart:async';

import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/packages/custom_yandex_map/custom_map.dart';
import 'package:f1_pet_project/common/utils/constants/assets.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/bottom_sheet_permissions.dart';
import 'package:f1_pet_project/core/circuits/map/components/map_controls_widget.dart';
import 'package:f1_pet_project/core/circuits/map/controllers/map_container_controller/map_container_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
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

  /// Ждём возврат из системных настроек после bottom sheet — не на каждый resume.
  bool _awaitingReturnFromSettings = false;
  bool _userPositionExceptionIsShowed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MapContainerController(points: widget.points);
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
    if (state == AppLifecycleState.resumed && _awaitingReturnFromSettings) {
      _awaitingReturnFromSettings = false;
      unawaited(_onReturnedFromSettings());
    }
  }

  /// После Settings: если доступ выдали — включаем геолокацию; иначе не дёргаем диалог снова.
  Future<void> _onReturnedFromSettings() async {
    final permission = await Geolocator.checkPermission();
    if (!mounted) {
      return;
    }
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      _userPositionExceptionIsShowed = false;
      _controller.mapController.updateUserPosition();
    }
  }

  void _onGetUserPositionError(Exception ex) {
    if (!_userPositionExceptionIsShowed) {
      final message = ex.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      Fluttertoast.showToast(msg: message, backgroundColor: AppTheme.red);
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
            _awaitingReturnFromSettings = true;
            final opened = await openAppSettings();
            if (opened && sheetContext.mounted) {
              Navigator.of(sheetContext).pop();
            } else {
              _awaitingReturnFromSettings = false;
            }
          },
          text: context.l10n.locationPermissionNeeded,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 327,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomMap(
          mapController: _controller.mapController,
          onPlacemarkPressed: widget.onPlacemarkPressed,
          mapObjectIcon: Assets.icons.pinUnselected,
          selectedMapObjectIcon: Assets.icons.pinRed,
          userIcon: Assets.icons.locationUser,
          points: widget.points,
          placemarkIconSize: 1,
          selectedPlacemarkIconSize: 1.2,
          clusterColor: AppTheme.red,
          clusterTextStyle: AppStyles.body.copyWith(
            fontSize: 24,
            height: 1,
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
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
    );
  }
}
