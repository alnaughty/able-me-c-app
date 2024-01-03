import 'package:able_me/models/geocoder/coordinates.dart';

class GeoAddress {
  /// The geographic coordinates.
  final Coordinates? coordinates;

  /// The formatted address with all lines.
  final String? addressLine;

  /// The localized country name of the address.
  final String? countryName;

  /// The country code of the address.
  final String? countryCode;

  /// The feature name of the address.
  final String? featureName;

  /// The postal code.
  final String? postalCode;

  /// The administrative area name of the address
  final String? adminArea;

  /// The administrative area code of the address
  final String? adminAreaCode;

  /// The sub-administrative area name of the address
  final String? subAdminArea;

  /// The locality of the address
  final String? locality;

  /// The sub-locality of the address
  final String? subLocality;

  /// The thoroughfare name of the address
  final String? thoroughfare;

  /// The sub-thoroughfare name of the address
  final String? subThoroughfare;

  GeoAddress({
    this.coordinates,
    this.addressLine,
    this.countryName,
    this.countryCode,
    this.featureName,
    this.postalCode,
    this.adminArea,
    this.adminAreaCode,
    this.subAdminArea,
    this.locality,
    this.subLocality,
    this.thoroughfare,
    this.subThoroughfare,
  });

  /// Creates an address from a map containing its properties.
  GeoAddress.fromMap(Map map)
      : this.coordinates = Coordinates.fromMap(map["coordinates"]),
        this.addressLine = map["addressLine"],
        this.countryName = map["countryName"],
        this.countryCode = map["countryCode"],
        this.featureName = map["featureName"],
        this.postalCode = map["postalCode"],
        this.locality = map["locality"],
        this.subLocality = map["subLocality"],
        this.adminArea = map["adminArea"],
        this.adminAreaCode = map["adminAreaCode"],
        this.subAdminArea = map["subAdminArea"],
        this.thoroughfare = map["thoroughfare"],
        this.subThoroughfare = map["subThoroughfare"];

  /// Creates a map from the address properties.
  Map toMap() => {
        "coordinates": this.coordinates?.toMap(),
        "addressLine": this.addressLine,
        "countryName": this.countryName,
        "countryCode": this.countryCode,
        "featureName": this.featureName,
        "postalCode": this.postalCode,
        "locality": this.locality,
        "subLocality": this.subLocality,
        "adminArea": this.adminArea,
        "adminAreaCode": this.adminAreaCode,
        "subAdminArea": this.subAdminArea,
        "thoroughfare": this.thoroughfare,
        "subThoroughfare": this.subThoroughfare,
      };
}
