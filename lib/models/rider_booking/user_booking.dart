import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserBooking {
  final int id, userId, type, status;
  final double price;
  final DateTime createdAt, updatedAt;
  final GeoPoint destination, pickupLocation;
  final bool isWheelChairFriendly, isRecurring, withPet;
  const UserBooking({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.destination,
    required this.pickupLocation,
    required this.isRecurring,
    required this.isWheelChairFriendly,
    required this.withPet,
  });
}
