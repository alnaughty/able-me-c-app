import 'package:able_me/view_models/notifiers/current_address_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAddress extends CurrentAddress {
  final int id;
  final String title;
  UserAddress(
      {required super.addressLine,
      required super.city,
      required super.coordinates,
      required super.locality,
      required super.countryCode,
      required this.id,
      required this.title});
  factory UserAddress.fromJson(Map<String, dynamic> json) {
    final List<double> c = json['coordinates']
        .toString()
        .split(',')
        .map((e) => double.parse(e))
        .toList();
    return UserAddress(
      addressLine: json['address'],
      city: json['city'],
      coordinates: GeoPoint(c.first, c.last),
      locality: json['state'],
      countryCode: json['country'],
      id: json['id'],
      title: json['title'] ?? "UNSET",
    );
  }

  CurrentAddress toAddress() => CurrentAddress(
      addressLine: addressLine,
      city: city,
      coordinates: coordinates,
      locality: locality,
      countryCode: countryCode);
}
