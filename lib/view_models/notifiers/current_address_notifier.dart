import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrentAddress {
  final GeoPoint coordinates;
  final String addressLine, city, countryCode, locality;
  const CurrentAddress(
      {required this.addressLine,
      required this.city,
      required this.coordinates,
      required this.locality,
      required this.countryCode});
}

final currentAddressNotifier = StateProvider<CurrentAddress?>((ref) {
  return null;
});
