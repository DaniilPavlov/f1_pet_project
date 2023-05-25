import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:f1_pet_project/domain/packages/xpage_map/src/wm/services/points_drawer.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Cluster drawer service.
class ClusterDrawer {
  static Future<ClusterizedPlacemarkCollection> getCluster({
    required MapObjectId clusterMapId,
    required List<Point> points,
    required Color clusterColor,
    TextStyle? clusterTextStyle,
    PlacemarkIcon? placemarkIcon,
    PlacemarkIcon? selectedPlacemarkIcon,
    Function(ClusterizedPlacemarkCollection, Cluster)? onClusterTap,
    Function(int)? onPointTap,
    int? selectedPointIndex,
  }) async {
    return ClusterizedPlacemarkCollection(
      mapId: clusterMapId,
      radius: 15,
      minZoom: 15,
      onClusterAdded: (
        self,
        cluster,
      ) async {
        return cluster.copyWith(
          appearance: cluster.appearance.copyWith(
            opacity: 0.75,
            icon: PlacemarkIcon.single(
              PlacemarkIconStyle(
                image: BitmapDescriptor.fromBytes(
                  await buildClusterAppearance(
                    cluster,
                    clusterColor: clusterColor,
                    clusterTextStyle: clusterTextStyle,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      onClusterTap: onClusterTap,
      placemarks: PointsDrawer.getPoints(
        points: points,
        onTap: onPointTap,
        icon: placemarkIcon,
        selectedIcon: selectedPlacemarkIcon,
        selectedIndex: selectedPointIndex,
      ),
    );
  }

  static Future<Uint8List> buildClusterAppearance(
    Cluster cluster, {
    required Color clusterColor,
    TextStyle? clusterTextStyle,
  }) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    const size = Size(200, 200);

    final fillPaint = Paint()
      ..color = clusterColor
      ..style = PaintingStyle.fill;

    final radius = min(max(cluster.size * 6.0, 30), 50).toDouble();

    final textPainter = TextPainter(
      text: TextSpan(
        text: cluster.size.toString(),
        style: clusterTextStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    final circleOffset = Offset(size.height / 2, size.width / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }
}
