import 'package:able_me/models/rider_booking/vehicle.dart';

class BookRiderDetails {
  final int id;
  final String name, email, lastName, fullname, firebaseId;
  final String? avatar;
  final bool isAccountValidated;
  final List services;
  final int ratingCount;
  final Vehicle vehicle;
  const BookRiderDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.lastName,
    required this.fullname,
    required this.avatar,
    required this.firebaseId,
    required this.isAccountValidated,
    required this.services,
    required this.ratingCount,
    required this.vehicle,
  });

  factory BookRiderDetails.fromJson(Map<String, dynamic> json) {
    return BookRiderDetails(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      lastName: json['lastname'],
      fullname: json['fullname'],
      avatar: json['avatar'],
      firebaseId: json['firebase_id'],
      isAccountValidated: json['is_account_validated'] == 1,
      services: json['services'] ?? [],
      ratingCount: int.parse(
        (json['rating_count'] ?? 0).toString(),
      ),
      vehicle: Vehicle.fromJson(
        json['vehicle'],
      ),
    );
  }
}
