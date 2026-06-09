import 'dart:math';

import 'package:yandex_mapkit/yandex_mapkit.dart';

/// Service for calculating bounds of points.
class GeometryService {
  static Geometry getGeometry(List<Point> points) {
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

    return Geometry.fromBoundingBox(
      BoundingBox(
        northEast: Point(
          latitude: highestLat + offset,
          longitude: highestLng + offset,
        ),
        southWest: Point(
          latitude: lowestLat - offset,
          longitude: lowestLng - offset,
        ),
      ),
    );
  }

  static double _calcBoundsOffset(
    double highestLat,
    double highestLng,
    double lowestLat,
    double lowestLng,
  ) {
    final distance = sqrt(
      pow(lowestLat - highestLat, 2) + pow(lowestLng - highestLng, 2),
    );

    return max(
      min(distance / 10, 1),
      0.001,
    );
  }
}
