import 'package:able_me/models/book_rider_details.dart';
import 'package:able_me/models/rider_booking/transportation_details.dart';
import 'package:able_me/models/rider_booking/user_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserTransportationBooking extends UserBooking {
  final TransportationDetails details;
  // final BookRiderDetails rider;
  UserTransportationBooking({
    required super.id,
    required super.userId,
    required super.type,
    required super.status,
    required super.price,
    required super.createdAt,
    required super.updatedAt,
    required super.destination,
    required super.pickupLocation,
    required super.isRecurring,
    required super.isWheelChairFriendly,
    required super.withPet,
    // required this.rider,
    required this.details,
  });

  factory UserTransportationBooking.fromJson(Map<String, dynamic> json) {
    final List<double> dest = json['destination']
        .toString()
        .split(',')
        .map((e) => double.parse(e))
        .toList();
    final List<double> pck = json['pickup_location']
        .toString()
        .split(',')
        .map((e) => double.parse(e))
        .toList();
    return UserTransportationBooking(
        id: json['id'],
        userId: json['customer_id'],
        type: json['type'],
        status: json['status'],
        price: double.parse(json['price'].toString()),
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        destination: GeoPoint(dest.first, dest.last),
        pickupLocation: GeoPoint(pck.first, pck.last),
        isRecurring: false,
        isWheelChairFriendly: json['is_wheelchair_friendly'] == 1,
        withPet: json['with_pet_companion'] == 1,
        // rider: rider,
        details: TransportationDetails.fromJson(json['transportation']));
  }
}
