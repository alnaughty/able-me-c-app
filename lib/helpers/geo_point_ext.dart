import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

extension EXT on GeoPoint {
  bool distanceIsWithin(Position pos, {required double kmRadius}) {
    const double pi = 3.1415926535897932;
    const double earthRadius = 6371.0; // Radius of the earth in kilometers

    double dLat = (pos.latitude - latitude) * (pi / 180.0);
    double dLon = (pos.longitude - longitude) * (pi / 180.0);

    double a = pow(sin(dLat / 2), 2) +
        cos(latitude * (pi / 180.0)) *
            cos(pos.latitude * (pi / 180.0)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c <= kmRadius; // Distance in kilometers
  }

  double distanceBetween(Position pos) {
    const double pi = 3.1415926535897932;
    const double earthRadius = 6371.0; // Radius of the earth in kilometers

    double dLat = (pos.latitude - latitude) * (pi / 180.0);
    double dLon = (pos.longitude - longitude) * (pi / 180.0);

    double a = pow(sin(dLat / 2), 2) +
        cos(latitude * (pi / 180.0)) *
            cos(pos.latitude * (pi / 180.0)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in kilometers
  }

  double distanceBetweenPoints(GeoPoint point) {
    const double pi = 3.1415926535897932;
    const double earthRadius = 6371.0; // Radius of the earth in kilometers

    double dLat = (point.latitude - latitude) * (pi / 180.0);
    double dLon = (point.longitude - longitude) * (pi / 180.0);

    double a = pow(sin(dLat / 2), 2) +
        cos(latitude * (pi / 180.0)) *
            cos(point.latitude * (pi / 180.0)) *
            pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in kilometers
  }
}

extension Convert on Position {
  GeoPoint toGeoPoint() => GeoPoint(latitude, longitude);
}
