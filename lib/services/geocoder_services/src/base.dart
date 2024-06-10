import 'package:able_me/models/geocoder/coordinates.dart' as coordinate;
import 'package:able_me/models/geocoder/geoaddress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Geocoding {
  /// Search corresponding addresses from given [coordinates].
  Future<List<GeoAddress>> findAddressesFromCoordinates(
      coordinate.Coordinates coordinates);

  /// Search corresponding addresses from given [coordinates] from [geopoint].
  Future<List<GeoAddress>> findAddressesFromGeoPoint(GeoPoint coordinates);

  /// Search for addresses that matches que given [address] query.
  Future<List<GeoAddress>> findAddressesFromQuery(String address);
}
