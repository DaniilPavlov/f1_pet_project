import 'package:elementary/elementary.dart';
import 'package:elementary_helper/elementary_helper.dart';
import 'package:f1_pet_project/domain/packages/custom_yandex_map/custom_map.dart';
import 'package:f1_pet_project/domain/widgets/map_container/map_container_wm.dart';
import 'package:f1_pet_project/presentation/widgets/map/map_controls_widget.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// * Контейнер с закругленными краями с картой внутри.
class MapContainer extends ElementaryWidget<MapContainerWM> {
  const MapContainer({
    required this.points,
    this.onAndressChanged,
    this.onPlacemarkPressed,
    this.onCameraPositionChanged,
    super.key,
  }) : super(createMapContainerWM);

  final List<Point> points;

  final Function(String)? onAndressChanged;

  final Function(int)? onPlacemarkPressed;

  final Function(double, double)? onCameraPositionChanged;

  @override
  Widget build(MapContainerWM wm) {
    return SizedBox(
      height: 327,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: StateNotifierBuilder<List<Point>>(
          listenableState: wm.listPointState,
          builder: (context, points) {
            return CustomMap(
              mapController: wm.mapController,
              onPlacemarkPressed: onPlacemarkPressed,
              mapObjectIcon: 'assets/icons/pin_unselected.png',
              selectedMapObjectIcon: 'assets/icons/pin_red.png',
              userIcon: 'assets/icons/location_user.png',
              points: points ?? [],
              placemarkIconSize: 1,
              selectedPlacemarkIconSize: 1.2,
              clusterColor: AppTheme.red,
              clusterTextStyle: AppStyles.caption.copyWith(
                color: Colors.white,
              ),
              onGetUserPositionError: wm.onGetUserPositionError,
              onCameraPositionChanged:
                  onAndressChanged != null ? wm.onCameraPositionChanged : null,
              userInterface: MapControlsWidget(
                onPlusPressed: wm.mapController.zoomIn,
                onMinusPressed: wm.mapController.zoomOut,
                onUserLocationPressed: wm.onUserLocationPressed,
              ),
            );
          },
        ),
      ),
    );
  }
}
