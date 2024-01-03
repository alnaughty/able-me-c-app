import 'package:able_me/models/geocoder/coordinates.dart';
import 'package:able_me/models/geocoder/geoaddress.dart';

abstract class Geocoding {
  /// Search corresponding addresses from given [coordinates].
  Future<List<GeoAddress>> findAddressesFromCoordinates(
      Coordinates coordinates);

  /// Search for addresses that matches que given [address] query.
  Future<List<GeoAddress>> findAddressesFromQuery(String address);
}
